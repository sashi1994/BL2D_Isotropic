function [stress]=stress_calculation_truss(res_stress_mises,elements,p,t)
nodes=p;
node_Stress=zeros(size(nodes,1),1);                                                    % max stress in each node 


for i=1:size(nodes,1)
    ind1=find(elements(:,1)==i);
    ind2=find(elements(:,2)==i);
    v=[];
    for j=1:size(ind1,1)
        v=[v;(res_stress_mises{3}(ind1(j)))];
    end
    
    for j=1:size(ind2,1)
        v=[v;(res_stress_mises{3}(ind2(j)))];
    end
    v=abs(v);
    node_Stress(i,1)=max(v);
end

figure(16);clf;trisurf(t,p(:,1),p(:,2),zeros(size(p,1),1),node_Stress,'facecolor','interp');colorbar();view(2);title('Von Mises');
stress=node_Stress;
end


