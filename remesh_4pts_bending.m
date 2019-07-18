% close all
truss=1;    % truss = 1 => barre , truss = 0 => coque
E = 2100;
poisson = .35;
thickness_truss = 10;
thickness_shell = 1;
taille=5;
force = -50;

% rand('state',1); % Always the same results
% set(gcf,'rend','z');
% fstats=@(p,t) fprintf('%d nodes, %d elements, min quality %.2f\n', size(p,1),size(t,1),min(simpqual(p,t)));

pv=[-90 -15;-60 -15;60 -15;90 -15;90 15;30 15;-30 15;-90 15;-90 -15];
minix=min(pv(:,1));maxix=max(pv(:,1));miniy=min(pv(:,2));maxiy=max(pv(:,2));

% pas=.5;

% grille=[];
% for px=minix:pas:maxix
%     for py=miniy:pas:maxiy
%         grille=[grille;px py];
%     end
% end
% figure(1);clf;hold on
% plot(pv(:,1),pv(:,2));
% hold off
% 
% fd=@(p) dpoly(p,pv);
% fh=@(p) huniform(p,pv);
% carte=[grille fh(grille)];
for i=0:10
%% running BL2D for mesh generation
    %     fh=@(p) carte_function(p,carte);
    %     [p,t]=distmesh2d(fd,fh,taille,[minix,miniy;maxix,maxiy],pv);
    if i==0
        dos('compile.bat')
    else
        dos(['echo adapt   ',int2str(i),' >> bl2d.env']);
        dos('compil_remaillage.bat')
    end
    %% visualization of mesh using Medit
%     visualization (i);
    figure(1);clf;title(['Meshing']);
    [nodes,edges,triangle]=BL2Dmeshread(['piece.0.',int2str(i),'.mesh'],1);
    p=nodes(:,1:2);
    t=triangle(:,1:3);
%     fstats(p,t);
%     figure(2);clf;trisurf(t,p(:,1),p(:,2),zeros(size(p,1),1),fh(p),'facecolor','interp');colorbar();view([0 90]);title('Map')
    %% definition of the bar elements
    elements=[t(:,1:2);t(:,2:3);t(:,[1 3])];
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
    if truss
        % Beam
        Write_INP_Function([[1:size(p,1)]' p], [[1:size(elements,1)]' elements], [indxy ones(size(indxy,1),2);indy zeros(size(indy,1),1) ones(size(indy,1),1)], [], [force/size(indcload,1);indcload], [], [], [E,poisson], [.4,thickness_truss])
    else
        % Shell
        Write_INP_Function_shell([[1:size(p,1)]' p], [[1:size(t,1)]' t], [indxy ones(size(indxy,1),2);indy zeros(size(indy,1),1) ones(size(indy,1),1)], [], [force/size(indcload,1);indcload], [], [], [E,poisson],thickness_shell)
    end
    fopen('STRESS+MISES.rpt','w');
    fopen('DEPLACEMENT.rpt','w');
    if truss
        status=dos('RUN_ABQ.bat');
    else
        status=dos('RUN_ABQ_shell.bat');
    end
    [res_stress_mises]=my_read_RPT('STRESS+MISES.rpt',6);
    %% Mapping between FE Simulation and BL2D mesh 
    if truss
        [cartes, cartesx, cartesy]=carte_grossiere(res_stress_mises,elements,p);
        figure(11);clf;trisurf(t,p(:,1),p(:,2),zeros(size(p,1),1),cartes,'facecolor','interp');colorbar();view([0 90]);title('Mises')
        figure(12);clf;trisurf(t,p(:,1),p(:,2),zeros(size(p,1),1),abs(cartesx),'facecolor','interp');colorbar();view([0 90]);title('S11')
        figure(13);clf;trisurf(t,p(:,1),p(:,2),zeros(size(p,1),1),abs(cartesy),'facecolor','interp');colorbar();view([0 90]);title('S22')
        map=1./cartes;
        ind=map<2;
        map(ind)=2;
        figure(14);clf;trisurf(t,p(:,1),p(:,2),zeros(size(p,1),1),map,'facecolor','interp');colorbar();view([0 90]);title('MAP')
    else
        [cartes, cartesx, cartesy, cartesxy]=carte_grossiere_shell(res_stress_mises,t,p);
        figure(11);clf;trisurf(t,p(:,1),p(:,2),zeros(size(p,1),1),cartes,'facecolor','interp');colorbar();view([0 90]);title('Mises')
        figure(12);clf;trisurf(t,p(:,1),p(:,2),zeros(size(p,1),1),abs(cartesx),'facecolor','interp');colorbar();view([0 90]);title('S11')
        figure(13);clf;trisurf(t,p(:,1),p(:,2),zeros(size(p,1),1),abs(cartesy),'facecolor','interp');colorbar();view([0 90]);title('S22')
        figure(14);clf;trisurf(t,p(:,1),p(:,2),zeros(size(p,1),1),abs(cartesxy),'facecolor','interp');colorbar();view([0 90]);title('S12')
    end
%     [nouvelle_carte,nouvelle_taille]=s2taille([p cartes'],grille,taille);
    BL2Dmapwrite(['piece.0.',int2str(i),'.h'],map')
    % adapt à 1 dans BL2D.env
    
%     taille
%     taille=(taille+nouvelle_taille)/2
%     if taille<1.5
%         taille=1.5;
%     end
%     carte=(carte+nouvelle_carte)./2;
%     carte=nouvelle_carte;
%     pause
end