function [carte, cartex, cartey]=carte_grossiere(res_stress_mises,elements,nodes)

cartex=[];
cartey=[];
carte=[];
for i=1:size(nodes,1)
%     i
%     if i==416
%         pause
%     end
    ind1=find(elements(:,1)==i);
    ind2=find(elements(:,2)==i);
    v=[];
    u1=[];
    for j=1:size(ind1,1)
        n=nodes(elements(ind1(j),2),:);
        u=nodes(i,:)-n;
        u=u./norm(u,2);
        u1=[u1;u];
        v=[v;(res_stress_mises{5}(ind1(j))+res_stress_mises{6}(ind1(j)))/2];
    end
    u2=[];
    for j=1:size(ind2,1)
        n=nodes(elements(ind2(j),1),:);
        u=nodes(i,:)-n;
        u=u./norm(u,2);
        u2=[u2;u];
        v=[v;(res_stress_mises{5}(ind2(j))+res_stress_mises{6}(ind2(j)))/2];
    end
    v=abs(v);
    u=[u1;u2];
    ux=[];
    uy=[];
    for j=1:size(u,1)
        ux(j)=abs(dot(u(j,:),[1 0]));
        uy(j)=abs(dot(u(j,:),[0 1]));
    end
    cartex(i)=(ux*v)/size(u,1);
    cartey(i)=(uy*v)/size(u,1);
    carte(i)=mean(v);
end
