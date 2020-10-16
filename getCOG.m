function [COG_MNI COG]=getCOG(maskfile,indx)
%GETCOG Find center of gravity of each AAL region and print to a text file. 
%
%   Remarks:
%       If the true center of gravity is outside the region, the voxel 
%       inside the region that is closest to this point is used as the 
%       actual center of gravity. 
%
%       MNI coordinates are reported. 

%Origin of MNI space
%origin=[128 128 128];
origin=[90 126 72];

%Voxel dimension
mm=1; 

%Read in AAL template

[hdr,data]=read(maskfile);

ind_aal=setdiff(unique(data(:)),0);

coor=zeros(length(ind_aal),3);

for i=1:length(indx)
    [x,y,z]=ind2sub(size(data),find(indx(i)==data));
    [val,ind_min]=min(sqrt((mean(x)-x).^2+(mean(y)-y).^2+(mean(z)-z).^2)); 
    coor(i,:)=[x(ind_min(1)),y(ind_min(1)),z(ind_min(1))]; 
end
COG=coor;
%Map voxel coordinates to MNI coordinates
COG_MNI=(coor-repmat(origin,length(ind_aal),1))*mm;
%allcoor(j,:)=coor;

%Write to a text file
%dlmwrite('/home/govindap/Monash004/IMAGE_HD/RestingState/Connectivity/Data/GroupAll/Connectomics/labels_stat3.txt',coor,'delimiter',' ','precision','%.3f');
%dlmwrite('/gpfs/M2Home/projects/Monash004/IMAGE_HD/Govindap/StudyIII/Scripts/mask_labels_vox.txt',allcoor,'delimiter',' ','precision','%.3f');
