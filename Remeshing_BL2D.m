close all;
%% User input 

list = {'Beam','Shell'};
[truss,tf] = listdlg('SelectionMode','single','ListString',list);
TF = isempty(truss);
if TF==1
    error(' you have to click on shell or truss  !!') 
end
prompt = {'Enter youngs modulus (E):','Poissons ratio','Thickness of truss (mm)','Thickness of shell (mm)','Length (mm)','Force in (KN)'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'2100','0.35','10','1','5','-500'};
answer = inputdlg(prompt,dlgtitle,dims,definput);

%% Saving all user input values 

E = str2num(answer{1,1});
poisson = str2num(answer{2,1});
thickness_truss = str2num(answer{3,1});
thickness_shell = str2num(answer{4,1});
taille=str2num(answer{5,1});
force = str2num(answer{6,1});
pv=[-90 -15;-60 -15;60 -15;90 -15;90 15;30 15;-30 15;-90 15;-90 -15];
minix=min(pv(:,1));maxix=max(pv(:,1));miniy=min(pv(:,2));maxiy=max(pv(:,2));

%% User INPUT
sigma_user= 50;                                                             % sigma_min given by user
minimum_size=2;                                                             % h_min

%% running BL2D for mesh generation
for i=0:10

    if i==0
        dos('compile.bat')                                                      % Initial meshing .bat file 
    else
        dos(['echo adapt   ',int2str(i),' >> bl2d.env']);                       % adaptation file .env 
        dos('compil_remaillage.bat')                                            % Remeshing .bat file 
    end
    %% visualization of mesh using Medit
    visualization (i);
%   figure(1);clf;title(['Meshing']);
    [nodes,edges,triangle]=BL2Dmeshread(['piece.0.',int2str(i),'.mesh'],1);
    p=nodes(:,1:2);                                                             % getting number of nodes
    t=triangle(:,1:3);                                                          % getting triangle generated for mesh
    %% definition of the bar elements
    elements=[t(:,1:2);t(:,2:3);t(:,[1 3])];                                    % Getting number of elements 
%   elements=mon_unique(elements);
    %% search for BC in Y only
    d=sqrt(sum([p(:,1)+60 p(:,2)+15].^2,2));
    indxy=find(d>-.1 & d<.1);
    %% search for BC in X and Y   
    d=sqrt(sum([p(:,1)-60 p(:,2)+15].^2,2));
    indy=find(d>-.1 & d<.1);
    %% Search the loads nodes
    d=sqrt(sum([p(:,1)+30 p(:,2)-15].^2,2));
    indcload=find(d>-.1 & d<.1);
    d=sqrt(sum([p(:,1)-30 p(:,2)-15].^2,2));
    indcload=[indcload;find(d>-.1 & d<.1)];
    %% Display the mesh + BC
    figure(1);clf;hold on;title(['Mesh and BCs']);
    triplot(t,p(:,1),p(:,2))
    plot(p(indcload,1),p(indcload,2),'or') 
    plot(p(indy,1),p(indy,2),'ok')
    plot(p(indxy,1),p(indxy,2),'og')
    hold off
    %% shell or beam calculation
    if truss==1
        % Beam
        Write_INP_Function([[1:size(p,1)]' p], [[1:size(elements,1)]' elements], [indxy ones(size(indxy,1),2);indy zeros(size(indy,1),1) ones(size(indy,1),1)], [], [force/size(indcload,1);indcload], [], [], [E,poisson], [.4,thickness_truss])
    elseif truss==2
        % Shell
        Write_INP_Function_shell([[1:size(p,1)]' p], [[1:size(t,1)]' t], [indxy ones(size(indxy,1),2);indy zeros(size(indy,1),1) ones(size(indy,1),1)], [], [force/size(indcload,1);indcload], [], [], [E,poisson],thickness_shell)
    end
    fopen('STRESS+MISES.rpt','w');
    fopen('DEPLACEMENT.rpt','w');
    if truss==1
        status=dos('RUN_ABQ.bat');                                              % runnning abaqus for FE simulation bleam elements
    elseif truss==2
        status=dos('RUN_ABQ_shell.bat');                                        % running abaqus for FE sumulation of shell elements
    end
      
    %% Mapping_sashi.....(in progress...)...stopping criteria ???????
    if truss==1
           [res_stress_mises]=my_read_RPT('STRESS+MISES.rpt',6);                           % report file generation for stress
           [res_disp]=my_read_RPT('DEPLACEMENT.rpt',3);                                    % report file generation for displacement
           [node_stress]=stress_calculation_truss(res_stress_mises,elements,p,t);
           [node_map,node_Stress]=mapping_sashi_truss(node_stress,p,sigma_user,minimum_size,1);
           figure(14);clf;trisurf(t,p(:,1),p(:,2),zeros(size(p,1),1),node_map,'facecolor','interp');colorbar();view(2);title('MAP');
           
    elseif truss==2
           [res_stress_mises]=my_read_RPT('STRESS+MISES.rpt',6);                           % report file generation for stress
           [res_disp]=my_read_RPT('DEPLACEMENT.rpt',3);                                    % report file generation for displacement
           [node_stress,node_Stress_S11,node_Stress_S12,node_Stress_S22]=stress_calculation_shell(res_stress_mises,elements,nodes,p,t);
           eigen=principal_direction(node_stress,node_Stress_S11,node_Stress_S12,node_Stress_S22);
           [node_map]= mapping_sashi_shell(node_stress,t,p,nodes,sigma_user,minimum_size);
           figure(14);clf;trisurf(t,p(:,1),p(:,2),zeros(size(p,1),1),node_map,'facecolor','interp');colorbar();view(2);title('MAP'); 
           
    end
    %% writing .h file for remeshing
       BL2Dmapwrite(['piece.0.',int2str(i),'.h'],node_map);
end