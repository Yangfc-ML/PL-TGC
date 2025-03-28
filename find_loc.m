function loc_list=find_loc(data,test_data)

[num1,~]=size(test_data);
[num2,~]=size(data);
loc_list=[];
for i=1:num1
    for loc=1:num2
        if all(test_data(i,:)==data(loc,:))
            loc_list=[loc_list,loc];
            break
        end
    end
end