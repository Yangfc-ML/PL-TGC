function W = origin_graph(data,k,label)

[num1,~]=size(data);
W = zeros(num1);
options = optimoptions('quadprog','Display', 'off','Algorithm','interior-point-convex' );
Dis=zeros(num1);
for i = 1:num1
    data1 = data(label(i,:),:);
    D = repmat(data(i,:),k,1)-data1;
    DD = D*D';
    lb = sparse(k,1);
    ub = ones(k,1);
    Aeq = ub';
    beq = 1;
    w = quadprog(2*DD,[],[],[], Aeq, beq, lb, ub,[], options);
    W(i,label(i,:)) = w';
end

end

