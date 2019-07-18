function [node_map,node_Stress,i]= mapping_sashi_truss(node_Stress,p,sigma_user,minimum_size,n)
%%
nodes=p;
% node_Stress=zeros(size(nodes,1),1);                                                    % strss in each node 
node_map=zeros(size(nodes,1),1);                                                       % nodes and length for node_map
% 
% 
% for i=1:size(nodes,1)
%     ind1=find(elements(:,1)==i);
%     ind2=find(elements(:,2)==i);
%     v=[];
%     for j=1:size(ind1,1)
%         v=[v;(res_stress_mises{3}(ind1(j)))];
%     end
%     
%     for j=1:size(ind2,1)
%         v=[v;(res_stress_mises{3}(ind2(j)))];
%     end
%     v=abs(v);
%     node_Stress(i,1)=max(v);
% end
% 
% %% figures generations
% figure(16);clf;trisurf(t,p(:,1),p(:,2),zeros(size(p,1),1),node_Stress,'facecolor','interp');colorbar();view(2);title('Von Mises');

%% node mapping
h_min=minimum_size;
if max(node_Stress(:,1))>sigma_user
    for i=1:size(node_map,1)
        if node_Stress(i)>=sigma_user
            node_map(i)=h_min(n);
        elseif node_Stress(i)< sigma_user
            node_map(i)=h_min(n)*(sigma_user/node_Stress(i));
        end
    end
else
    fprintf('Optimized structure below the given limit of stress is generated.');
    error('STOP');
end

end