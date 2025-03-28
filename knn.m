function acc=knn(data,partial_target,test_data,test_target,k,label,loc_list)

acc_num=0;
[num1,~]=size(test_data);
[num2,~]=size(data);
[target_length,~]=size(partial_target);
W=origin_graph(data,k,label);

for i=1:num1
    target=zeros(target_length,1);
    for j=1:k
        target=target+W(loc_list(:,i),label(loc_list(:,i),j))*partial_target(:,label(loc_list(:,i),j));
    end
    max_num=max(target);
    max_idx=find(target==max_num);
    if(test_target(max_idx,i)==1)
        acc_num=acc_num+1;
    end
end
acc=acc_num/num1;