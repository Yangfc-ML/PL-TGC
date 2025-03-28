function label=built_label(data,k)

[num1,~]=size(data);
label=[];
for i=1:num1
    temp_dist=[];
    temp_label=[];
    for j=1:num1
        distance=pdist2(data(i,:),data(j,:));
        temp_dist=[temp_dist,distance];
    end
    temp=sort(temp_dist);
    temp=temp(1,2:k+1);
    for j=temp(1:k)
        idx=find(temp_dist==j);
        temp_label=[temp_label,idx];
        
    end
    temp_label=temp_label(1,1:10);
    label=[label;temp_label];
end