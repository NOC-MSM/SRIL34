vi tifunction Temp_out=Int_RESTART_2D_reanalysis(lat_h,lon_h,mask_h,lat_c1,lon_c1,mask_c,field_2D)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolation of 2D 
% Anna Katavouta, NOC, Liverpool 07/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Read the [lat_c lon_c]=meshgrid(lat_c1,lon_c1);
[lat_c lon_c]=meshgrid(lat_c1,lon_c1);

Temp_in=ncread('<path_to_file>/CMEMS_2019_01_01_download.nc','zos');
Temp_out=griddata(double(lon_c),double(lat_c),double(mask_c(:,:,1).*Temp_in),double(lon_h),double(lat_h),'linear');
Temp_out=inpaint_nans(Temp_out,2);
Temp_out(isnan(Temp_out))=0;
% Temp_out=fillmissing(Temp_out,'nearest');
% Temp_out=mask_h(:,:,1).*Temp_out;
%  Temp_out(1,1)=0;Temp_out(end,end)=0;Temp_out(end,1)=0;Temp_out(1,end)=0;

    % the same results, just in case griddata cannot handle nan use
    % explicitly the interpolant
%     LL=mask_c(:,:,1).*Temp_in;
%     F = scatteredInterpolant(double(lon_c(:)),double(lat_c(:)),double(LL(:)),'linear');
%     F_new=F(double(lon_h(:)),double(lat_h(:)));
%     F_new2=reshape(F_new,size(lon_h,1),size(lon_h,2));

%% read extra / set up the file to write / write the file
lev=ncread('<path_to_file>/domain_cfg.nc','nav_lev');
x=size(lon_h,1);y=size(lon_h,2);z=length(lev);


filename='SRI_TEST.nc'
if ~isfile(filename)

    %kt=ncread('SEAsia_R12_notide_03506400_restart.nc','kt');
    time=1;%time=ncread('SEAsia_R12_notide_03506400_restart.nc','time_counter');
    %ndastp=ncread('SEAsia_R12_notide_03506400_restart.nc','ndastp');
    %adatrj=0%=ncread('SEAsia_R12_notide_03506400_restart.nc','adatrj');
    ntime=0;%ntime=ncread('SEAsia_R12_notide_03506400_restart.nc','ntime');
    %rdt=ncread('SEAsia_R12_notide_03506400_restart.nc','rdt');
    e3t_new=ncread('<path_to_file>/domain_cfg.nc','e3t_0');

    nccreate(filename,'nav_lat', 'Dimensions',{'x',x,'y',y})
    ncwrite(filename,'nav_lat',lat_h);

    nccreate(filename,'nav_lon', 'Dimensions',{'x',x,'y',y})
    ncwrite(filename,'nav_lon',lon_h);

    nccreate(filename,'nav_lev', 'Dimensions',{'z',z})
    ncwrite(filename,'nav_lev',lev);

    nccreate(filename,'time_counter', 'Dimensions',{'t',Inf},'Datatype','double')
    ncwrite(filename,'time_counter',time);

%     nccreate(filename,'kt', 'Dimensions',{'t',Inf},'Datatype','double')
%     ncwrite(filename,'kt',kt);

%     nccreate(filename,'ndastp', 'Dimensions',{'t',Inf},'Datatype','double')
%     ncwrite(filename,'ndastp',ndastp);
% 
%     nccreate(filename,'adatrj', 'Dimensions',{'t',Inf},'Datatype','double')
%     ncwrite(filename,'adatrj',adatrj);

    nccreate(filename,'ntime', 'Dimensions',{'t',Inf},'Datatype','double')
    ncwrite(filename,'ntime',ntime);

%     nccreate(filename,'rdt', 'Dimensions',{'t',Inf},'Datatype','double')
%     ncwrite(filename,'rdt',rdt);

    nccreate(filename,'e3t_b', 'Dimensions',{'x',x,'y',y,'z',z,'t',Inf},'Datatype','double')
    ncwrite(filename,'e3t_b',e3t_new);

    nccreate(filename,'e3t_n', 'Dimensions',{'x',x,'y',y,'z',z,'t',Inf},'Datatype','double')
    ncwrite(filename,'e3t_n',e3t_new);
end

field_2D
nccreate(filename,field_2D, 'Dimensions',{'x',x,'y',y,'t',Inf},'Datatype','double')
ncwrite(filename,field_2D,Temp_out);

end

