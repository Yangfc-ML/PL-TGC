
load('data//lost sample.mat');

lit1=[];
lit2=[];
k=10;

[ins_num,~]=size(data);
kdtree = KDTreeSearcher(data);
[label,~] = knnsearch(kdtree,data,'k',k+1);
label = label(:,2:k+1);
W=PL_TGC(data,partial_target,label,k,100,0.01,0.5);

for i =1:10

    load(['data//lost sample' num2str(i) '.mat']);


    loc_list=find_loc(data,test_data);

    acc1=knn(data,partial_target,test_data,test_target,k,label,loc_list);
    lit1=[lit1 acc1];
    fprintf('special classification accuracy: %f\n',acc1);

    acc2=knn_modify(data,partial_target,test_data,test_target,k,label,W,loc_list);
    lit2=[lit2 acc2];
    fprintf('PL-TGC classification accuracy: %f\n',acc2);

end
fprintf('special accuracy: %f\n',mean(lit1));
fprintf('PL-TGC accuracy: %f\n',mean(lit2));
