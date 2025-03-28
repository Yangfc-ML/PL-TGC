function W = PL_TGC(data,partial_target,label,k,lambda1,lambda2,threshold)

[num1,~]=size(data);
W = zeros(num1);
options = optimoptions('quadprog','Display', 'off','Algorithm','interior-point-convex' );
Dis=zeros(num1);
for i = 1:num1
    data1 = data(label(i,:),:);
    traintarget=partial_target';
    y_=1-[traintarget(i,:)' traintarget(label(i,:),:)'];
    Y=y_'*y_;
    maxnum=max(max(Y));
    minnum=min(min(Y));
    if(maxnum-minnum==0)
        Y=Y./maxnum;
    else
        Y=(Y-minnum)./(maxnum-minnum);
    end
    Y=1-Y;
    Dis(i,label(i,:))=Y(1,2:k+1)';
    D = repmat(data(i,:),k,1)-data1;
    DD = D*D';
    lb = sparse(k,1);
    ub = ones(k,1);
    Aeq = ub';
    beq = 1;
    w = quadprog(2*DD,[],[],[], Aeq, beq, lb, ub,[], options);
    W(i,label(i,:)) = w';
end
Dis=Dis';
W=W';
[Dis,W,A,B]=update_DW(W,Dis,lambda1,lambda2,threshold,data,k,label);
W=W';
end

