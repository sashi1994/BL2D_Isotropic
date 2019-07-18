function BL2Dmapwrite(filename,val)

disp(['Ecriture de ',filename]);
fid=fopen(filename,'w');
if fid == -1 
    error('Le fichier n a pas pu être ouvert, vérifier le nom ou le chemin')
end
longueur=size(val,1);
largeur=size(val,2);
fprintf(fid, '%s\r\n', [num2str(longueur),' ',num2str(largeur)]);
for i=1:longueur
    texte=[];
    for j=1:largeur
        texte=[texte num2str(val(i,j)) ' '];
    end
%     texte=[texte 
%     fprinf(fid, texte);
    fprintf(fid, '%s\r\n', texte);
end
fclose(fid) 
