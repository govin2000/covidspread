%This script is used to simulate NDM model on healthy connectome for
%predicting neurological events in COVID-19 patients.


clear all;
clc;

GrayMatter=readtable('GrayMatter.xlsx');
IIT_Indx=load('IITconnode.txt');

desikan_labels=GrayMatter.DK;
con_labels=GrayMatter.Con;
data=table2array(GrayMatter(:,3:size(GrayMatter,2)));

nd=[];
nc=[];

for i=1:length(con_labels)
    
    dk=desikan_labels{i};
    cn=con_labels{i};
    nt=strsplit(dk,' ');
    nd(i)=str2num(nt{1});
    
    nt=strsplit(cn,' ');
    nc(i)=str2num(nt{1});
    
end

[s_nc, i_nc]=sort(nc);
s_nd=nd(i_nc);

data=data(i_nc,:);

data(isnan(data))=0;
total_cases=sum(data');

papers=data;
papers(find(papers>0))=1;
total_papers=sum(papers');
np=size(data,2);

N_cases=123;
w=(total_cases/N_cases)*100

%read table
Conmat_raw=load('IIT_connectivity_matrix.txt');
Conmat=Conmat_raw(1:84,1:84);
sz=size(Conmat,1);

indx=1:sz;

wt=zeros(1,sz);
wt(s_nc)=w;

beta=1;
time=1:1:15;
lh_seed=[1:42]; %This are roi locations corresponding to left and right hand side of the brain
rh_seed=[50:84,43:49];


%generate Laplacian
[eig_val,V]=generateLaplacian(Conmat); % Generate lapacian vectors 

[r_val xt_all atr_all]=runSeedingNDM_v2(eig_val,V,time,beta,wt,lh_seed,rh_seed);

fig_handle=figure('DefaultAxesFontSize',24,'color','w')
plot(r_val,'-','linewidth',2)

xlabel('Time (days)')
ylabel('Correlation (r-value)');

[max_val max_indx]=max(max(r_val));
[rv iv]=sort(max(r_val),'descend');

max_rval=max(r_val);
node_atr=[max_rval,max_rval(36:42),max_rval(1:35)];

node_labels=[1:84];

[COG_MNI COG]=getCOG('IIT_GM_Desikan_atlas.nii',IIT_Indx);

dlmwrite('Coordinates.txt',COG_MNI,'delimiter','\t');
dlmwrite('NodeAttributes_NDM.txt',rescale(node_atr(:),1, 10),'delimiter','\t');

%legend('Amygdala','MedialOrbitofrontal cortex','Precuneus')

%for i=1:32
% [r_val_1,xt_all_1,wt_all_1]=runTargetedNDM(eig_val,V,time,beta,[13,62],wt);
% [r_val_2,xt_all_2,wt_all_2]=runTargetedNDM(eig_val,V,time,beta,[41,48],wt);
% [r_val_3,xt_all_3,wt_all_3]=runTargetedNDM(eig_val,V,time,beta,[24,73],wt);
% fig_handle=figure('DefaultAxesFontSize',24,'color','w')
% plot(r_val_1)
% hold on
% plot(r_val_2)
% hold on
% plot(r_val_3)
% xlabel('Time (days)')
% ylabel('Correlation (r-value)')
% legend('Amygdala','MedialOrbitofrontal cortex','Precuneus')

yval=squeeze(xt_all(:,1,iv(1)));
xval=squeeze(atr_all(:,iv(1)));

 fig_handle=figure('DefaultAxesFontSize',24,'color','w')
 [r p]=corr(xval,yval)
 scatter(xval,yval,'b','LineWidth',1);
 %lsline
 ylabel('Predicted values','Fontsize', 24);
 xlabel('Measured values','Fontsize', 24);
% 
