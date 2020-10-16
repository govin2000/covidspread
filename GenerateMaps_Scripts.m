clear all;
clc;

GrayMatter=readtable('GrayMatter.xlsx');

desikan_labels=GrayMatter.DK;

data=table2array(GrayMatter(:,3:size(GrayMatter,2)));

data(isnan(data))=0;
%N_cases=sum(max(data));

total_cases=sum(data');

N_cases=123;

papers=data;
papers(find(papers>0))=1;
total_papers=sum(papers');
np=size(data,2);

w=(total_cases/N_cases)*100;

%w=(total_papers/np).*total_cases;

ns=[];

for i=1:length(desikan_labels)
    
    dk=desikan_labels{i};
    nt=strsplit(dk,' ');
    ns(i)=str2num(nt{1});
end

ws=w;
%ws=rescale(w,1, 10);
%[COG_MNI COG]=getCOG(atlasbrain);
%generateScatteredVolumes(atlasbrain,ns(:),ws(:),COG,outbrain);
generateFSVolumes('IIT_GM_Desikan_atlas.nii',ns(:),ws(:),'IIT_GM_Desikan_Covid19.nii');
