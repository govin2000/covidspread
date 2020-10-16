function [r_val, xt_all, atr_all]=runSeedingNDM_v2(eig_val,V,time,beta,weights,lh_seed,rh_seed)

%weights=diff_sym;
r_val=[];
xt_all=[];
atr_all=[];
ns=1:length(weights);

for i=1:length(weights)/2;
    xt=[];
    pt=[];
    C0=zeros(1,length(eig_val))';
    i
    C0(lh_seed(i))=100;
    C0(rh_seed(i))=100;
    u_ns=setdiff(ns,[lh_seed(i),rh_seed(i)]);
    xt=RunNDM(V,eig_val,C0,time,beta);
    r_val(:,i)=corr(xt(u_ns,:),weights(u_ns)','type','Pearson');
    xt_all(:,:,i)=xt(u_ns,:);
    atr_all(:,i)=weights(u_ns)';
    
end

