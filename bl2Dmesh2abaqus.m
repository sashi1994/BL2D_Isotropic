function bl2Dmesh2abaqus(mesh_file,type)

% mesh_file est un fichier .mesh venant de BL2D contenant une liste de noeud, arrêtes et triangles
% type est 'beam' ou 'shell'

texte=fileread(mesh_file)
