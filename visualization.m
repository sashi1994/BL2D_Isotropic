function visual = visualization (i)                                    
% this function will help to visualize the structure in the medit software
% for each itiration.

rr=int2str(i);
piece='piece.0.';
last='.mesh';
piece=strcat(piece,rr);
piece=strcat(piece,last);
copyfile(piece,'C:\Users\maduguls\Documents\Sashi_Kiran\BL2D\Medit');
one='C:\Users\maduguls\Documents\Sashi_Kiran\BL2D\Medit\medit piece.0.';
two='.mesh &';
visual=strcat(one,rr);
visual=strcat(visual,two);
dos(visual);


end


