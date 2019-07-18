function [res] = my_read_RPT(FILENAME,nb_champ)

fid = fopen(FILENAME, 'r');

a=fgetl(fid);
ok=0;
while ~ok
    if size(a,2)>=10
        if (~isequal(a(1:10),'----------'))
            a=fgetl(fid);
        else
            ok=1;
        end
    else
        a=fgetl(fid);
    end
end

format='';
for i=1:nb_champ
    format=[format,'%f '];
end
res = textscan(fid, format);

