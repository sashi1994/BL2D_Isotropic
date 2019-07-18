function [carte, cartex, cartey, cartexy]=carte_grossiere_shell(res_stress_mises,elements,nodes)

% mises en colonne 3
% S11 en colonne 4
% S12 en colonne 5
% S22 en colonne 6

cartex=[];
cartey=[];
carte=[];
for i=1:size(nodes,1)
%     i
%     if i==416
%         pause
%     end
    ind=find(elements(:,1)==i | elements(:,2)==i | elements(:,3)==i);
    v=[];
    l=[];
    for j=1:size(ind,1)
        n=nodes(elements(ind(j),1:3),:);
        n=mean(n,1);
        length=norm(nodes(i,:)-n,2);
        l=[l;length];
        v=[v;res_stress_mises{3}(ind(j)) res_stress_mises{4}(ind(j)) res_stress_mises{5}(ind(j)) res_stress_mises{6}(ind(j))];
    end
    l=1./l;
    cartex(i)=sum(v(:,2).*l)/sum(l);
    cartey(i)=sum(v(:,4).*l)/sum(l);
    cartexy(i)=sum(v(:,3).*l)/sum(l);
    carte(i)=sum(v(:,1).*l)/sum(l);
end
