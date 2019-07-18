function [nodes,edges,tri]=BL2Dmeshread(meshfile,nofig)
if nargin<2
    nofig=0;
end
nodes=[];
edges=[];
tri=[];
disp(['lecture de ',meshfile]);
fid=fopen(meshfile);
if fid == -1 
    error('Le fichier n a pas pu être ouvert, vérifier le nom ou le chemin')
end
val=[];
while feof(fid) == 0
    A=fgetl(fid);
    if size(A,2)>8
        if isequal(A(2:9),'Vertices')
            A=fgetl(fid);
            nb=str2double(A);
            for j=1:nb
                A=fgetl(fid);
                val = strsplit(A,' ');
                if size(val,2)>3
                    nodes=[nodes;str2double(val{1,2}) str2double(val{1,3}) str2double(val{1,4})];
                else
                    nodes=[nodes;str2double(val{1,1}) str2double(val{1,2}) str2double(val{1,3})];
                end
            end
            A=fgetl(fid);
            A=fgetl(fid);
            nb=str2double(A);
            for j=1:nb
                A=fgetl(fid);
                val = strsplit(A,' ');
                if size(val,2)>3
                    edges=[edges;str2num(val{1,2}) str2num(val{1,3}) str2num(val{1,4})];
                else
                    edges=[edges;str2num(val{1,1}) str2num(val{1,2}) str2num(val{1,3})];
                end
            end
            A=fgetl(fid);
            A=fgetl(fid);
            nb=str2double(A);
            for j=1:nb
                A=fgetl(fid);
                val = strsplit(A,' ');
                if size(val,2)>3
                    tri=[tri;str2num(val{1,2}) str2num(val{1,3}) str2num(val{1,4}) str2num(val{1,5})];
                else
                    tri=[tri;str2num(val{1,1}) str2num(val{1,2}) str2num(val{1,3}) str2num(val{1,4})];
                end
            end
        end
    end
end
fclose(fid); 

% if nofig>0
%    clf
%     figure(nofig)=triplot(tri(:,1:3),nodes(:,1),nodes(:,2));
end

