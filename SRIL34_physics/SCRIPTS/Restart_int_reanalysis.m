clear;clc;close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolation of restart file from hybrid s-z coordinates from 1/12
% to 1/36 for SEAsia model (cannot be doen with Agrif or SIREN due to
% vertical coordinates)
% Anna Katavouta, NOC, Liverpool 07/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath '/vkamino/scratch/accord/SEAsia_R36/RESTART_SEAsiaR36/Inpaint_nans'
%% read coordinates to be interpolated into
 file='/projectsa/accord/SANH_jrule/PyNEMO3/SRIL34_PynemoFiles/domain_cfg.nc';
% lat_R36=ncread(file,'nav_lat');
% lon_R36=ncread(file,'nav_lon');
e3t_R36=ncread(file,'e3t_0');
e3u_R36=e3t_R36;
e3v_R36=e3t_R36;


file='/projectsa/accord/SANH_jrule/PyNEMO3/SRIL34_PynemoFiles/mesh_mask.nc';
mask_t=double(ncread(file,'tmask'));
mask_u=double(ncread(file,'umask'));
mask_v=double(ncread(file,'vmask'));
lat_R36=ncread(file,'nav_lat');
lon_R36=ncread(file,'nav_lon');
e3t_R36=ncread(file,'e3t_0');
e3u_R36=ncread(file,'e3u_0');
e3v_R36=ncread(file,'e3v_0');

%% read coordinates from Restart to be interpolated 
file='/scratch/jrule/CMEMS_PHY_001_024/CMEMS_2019_01_01_download.nc';
lat_12=ncread(file,'latitude');
lon_12=ncread(file,'longitude');
Depth_12=ncread(file,'depth');
mask_12=ncread(file,'so');mask_12(~isnan(mask_12))=1;mask_12(isnan(mask_12))=0;

%% estimate depths from e3 level thickness
Depth_R36(:,:,1)=(e3t_R36(:,:,1)./2).*mask_t(:,:,1);

for zz=2:size(e3t_R36,3)
    Depth_R36(:,:,zz)=nansum((e3t_R36(:,:,1:zz-1).*mask_t(:,:,1:zz-1)),3)+(e3t_R36(:,:,zz)./2).*mask_t(:,:,zz);
end

%fix for weird SRI that has zeros around the boundary!!!!
%just fill the depths with adjacent point to the boundary
Depth_R36(1:end,1,:)=Depth_R36(1:end,2,:);
Depth_R36(1:end,end,:)=Depth_R36(1:end,end-1,:);
Depth_R36(1,1:end,:)=Depth_R36(2,1:end,:);
Depth_R36(end,1:end,:)=Depth_R36(end-1,1:end,:);

%% fields to be interpolate from RESTART and interpolation 
field_2D=string( {'sshn'} );
field_3D_n=string( {'un';'vn';'tn';'sn'} );
mask_12(mask_12==0)=nan;mask_t(mask_t==0)=nan;mask_u(mask_u==0)=nan;mask_v(mask_v==0)=nan;

%interpolate the 2D separate for before and now
for ii=1:length(field_2D)
   Temp_out_2D=Int_RESTART_2D_reanalysis(lat_R36,lon_R36,mask_t,lat_12,lon_12,mask_12,field_2D(ii));
end

for ii=1:length(field_3D_n)    
    if strcmp(field_3D_n(ii),'sn') || strcmp(field_3D_n(ii),'tn')
       mask_in=mask_t;
       Depth_R36_in=Depth_R36;
    end
    if strcmp(field_3D_n(ii),'un')
       mask_in=mask_t;
       Depth_R36_in=Depth_R36;
    end
    if strcmp(field_3D_n(ii),'vn')
       mask_in=mask_t;
       Depth_R36_in=Depth_R36;
    end
    Temp_out_3D1=Int_RESTART_3D_reanalysis(lat_R36,lon_R36,mask_in,Depth_R36_in,lat_12,lon_12,mask_12,Depth_12,field_3D_n(ii));
end
