function [Dis,W,A,B]=update_DW(W, Dis0, lambda1,lambda2,threshold,train_data,k,neighbor)

options = optimoptions('quadprog','Display','off','Algorithm','interior-point-convex' );

W0=(W+W')/2;
D_s=sum(W0,2);
L=diag(D_s)-W0;

n=size(Dis0,1);
tol = 1e-8;
maxiter=500;
mu=1e-5;
rho=1.1;
maxmu=1e10;

A=zeros(n);
B=zeros(n);
Phi1=zeros(n);
Phi2=zeros(n);
I=eye(n);

for iter=1:maxiter
    
    % Dis subproblem
    Dis=(mu*A-Phi1)*inv(2*lambda2*L+mu*I);
    
    % A subproblem
    A=(mu*Dis+Phi1)./(2*lambda1*(B.*B)+(mu.*ones(n)));
    A(Dis0>=threshold)=Dis0(Dis0>=threshold);
    A(A>1)=1;
    A(A<0)=0;
    
    % B subproblem
    B=(mu*W+Phi2)./(2*lambda1*(A.*A)+(mu.*ones(n)));
    B(B<0)=0;
    B(B>1)=1;
    
    % W subproblem
    for i=1:n
        train_data1=train_data(neighbor(i,:),:);
        D = repmat(train_data(i,:),k,1)-train_data1;
        DD = D*D';
        C=[];
        for j=neighbor(i,:)
            C_j=norm((Dis(:,i)-Dis(:,j)),2)^2;
            C=[C,C_j];
        end
        Phi2_j=Phi2(neighbor(i,:),i)';
        B_j=B(neighbor(i,:),i)';
        lb = sparse(k,1);
        ub = ones(k,1);
        Aeq = ub';
        beq = 1;
        w = quadprog(2*(DD+(mu/2)*eye(k)),(lambda2*C)+(Phi2_j)-(mu*B_j),[],[], Aeq, beq, lb, ub,[], options);
        W(neighbor(i,:),i) = w;
    end
    
    W0=(W+W')/2;
    D_s=sum(W0,2);
    L=diag(D_s)-W0;
    
    d1=Dis-A;
    d2=W-B;
    
    chg = max([max(abs(d1(:))),max(abs(d2(:)))]);
    if chg < tol
        break;
    end
    
    if mod(iter,50)==0
        disp([num2str(iter),' Err Dis-A: ',num2str(norm(d1,'fro')),'. Err W-B: ',num2str(norm(d2,'fro'))])
    end
    
    Phi1=Phi1+mu*d1;
    Phi2=Phi2+mu*d2;
    mu = min(rho*mu,maxmu);
    
end

end
