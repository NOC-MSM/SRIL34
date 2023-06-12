function Temp_out=Int_RESTART_3D_reanalysis(lat_h,lon_h,mask_h,Depth_h,lat_c1,lon_c1,mask_c,Depth_c,field_3D)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolation of 3D field in hybrid s-z coordinates 
% Anna Katavouta, NOC, Liverpool 07/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Read the field and interpolate
if strcmp(field_3D,'sshn')
    name_read=string( {'zos'} );
end
if strcmp(field_3D,'un')
    name_read=string( {'uo'} );
end
if strcmp(field_3D,'vn')
    name_read=string( {'vo'} );
end
if strcmp(field_3D,'sn')
    name_read=string( {'so'} );
end
if strcmp(field_3D,'tn')
    name_read=string( {'thetao'} );
end
Temp_in=ncread('/scratch/jrule/CMEMS_PHY_001_024/CMEMS_2019_01_01_download.nc',[name_read]);

[lat_c lon_c]=meshgrid(lat_c1,lon_c1);

    
    % 1. interpolate horizontaly
    Temp2=double(squeeze(Temp_in.*mask_c));%Temp2(isnan(Temp2))=[];
    for kk=1:size(Temp2,3)
        Temp_in_21(:,:,kk)=griddata(double(lon_c),double(lat_c),double(Temp2(:,:,kk)),double(lon_h),double(lat_h),'linear');
        %flood only for T and S not for velocities
        if strcmp(field_3D,'tn') || strcmp(field_3D,'sn')
       %Temp_out=mask_h.*fillmissing(Temp_out,'nearest');
%        for kv=1:size(Temp_out,3)
           %Temp_in_2(:,:,kk)=fillmissing(Temp_in_21(:,:,kk),'nearest');
           Temp_in_2(:,:,kk)=inpaint_nans(Temp_in_21(:,:,kk),2);
        else
           Temp_in_2(:,:,kk)=Temp_in_21(:,:,kk);
        end
        %account for shallow domain that may have no values at last depths
        LL=Temp_in_2(:,:,kk);
        if isempty(find(LL(:)~=0))
            Temp_in_2(:,:,kk)=nan;
        end
    end
    


    %2. interpolate vertically to original R36 grid
    for k1=1:size(Temp_in_2,1)
        for k2=1:size(Temp_in_2,2)
            Temp_d=double(squeeze(Depth_h(k1,k2,:)).*squeeze(mask_h(k1,k2,:)));Temp_d(isnan(Temp_d))=[];
            if length(Temp_d)>0
                TT1=interp1(Depth_c,double(squeeze(Temp_in_2(k1,k2,:))),Temp_d);%double(squeeze(Depth_h(k1,k2,:))));
                DD=TT1;DD(isnan(DD))=[];
                if length(TT1)<31
                 TT1(length(TT1)+1:31)=nan;
                end
                 %extrapolate a value 
                  k_end=length(DD);%leave the bottom value zero
                  k_start=find(Temp_d<Depth_c(1));%extrapolate value at the surface though
                  if strcmp(field_3D,'tn') || strcmp(field_3D,'sn')
                  if length(k_end)>0
                  TT1(k_end+1:31)=TT1(k_end);
                  end
                  end
                 if length(k_start)>0
                 TT1(k_start)=TT1(nanmax(k_start+1));
                 end
             else
                TT1(1:size(mask_h,3))=nan;
            end
            Temp_out(k1,k2,:)=TT1;
        end
    end
    if strcmp(field_3D,'tn') || strcmp(field_3D,'sn')
        for kv=1:size(Temp_out,3)
            Temp_out(:,:,kv)=inpaint_nans(double(Temp_out(:,:,kv)),1); %make it double precision else inpaint nan does not like it
        end
        %julia this is for masking, in theory it should be fine but if you
        %want flooded fields just comment the two following lines
%          Temp_out=mask_h.*Temp_out;
%          Temp_out(isnan(Temp_out))=0;
    else
        %Temp_out=mask_h.*Temp_out;
        Temp_out(isnan(Temp_out))=0;
    end
     Temp_out(isnan(Temp_out))=0;
    
%% read extra / set up the file to write / write the file
x=size(lon_h,1);y=size(lon_h,2);z=size(Temp_out,3);
lev=ncread('/projectsa/accord/SANH_jrule/PyNEMO3/SRIL34_PynemoFiles/domain_cfg.nc','nav_lev');

filename='SRI_TEST.nc'

if ~isfile(filename) 

   % kt=ncread('SEAsia_R12_notide_03506400_restart.nc','kt');
    time=1;%time=ncread('SEAsia_R12_notide_03506400_restart.nc','time_counter');
   % ndastp=ncread('SEAsia_R12_notide_03506400_restart.nc','ndastp');
   % adatrj=0%=ncread('SEAsia_R12_notide_03506400_restart.nc','adatrj');
    ntime=0;%ntime=ncread('SEAsia_R12_notide_03506400_restart.nc','ntime');
   % rdt=ncread('SEAsia_R12_notide_03506400_restart.nc','rdt');
    e3t_new=ncread('/projectsa/accord/SANH_jrule/PyNEMO3/SRIL34_PynemoFiles/domain_cfg.nc','e3t_0');

    nccreate(filename,'nav_lat', 'Dimensions',{'x',x,'y',y})
    ncwrite(filename,'nav_lat',lat_h);

    nccreate(filename,'nav_lon', 'Dimensions',{'x',x,'y',y})
    ncwrite(filename,'nav_lon',lon_h);

    nccreate(filename,'nav_lev', 'Dimensions',{'z',z})
    ncwrite(filename,'nav_lev',lev);

    nccreate(filename,'time_counter', 'Dimensions',{'t',Inf},'Datatype','double')
    ncwrite(filename,'time_counter',time);

   % nccreate(filename,'kt', 'Dimensions',{'t',Inf},'Datatype','double')
   % ncwrite(filename,'kt',kt);

   % nccreate(filename,'ndastp', 'Dimensions',{'t',Inf},'Datatype','double')
   % ncwrite(filename,'ndastp',ndastp);

   % nccreate(filename,'adatrj', 'Dimensions',{'t',Inf},'Datatype','double')
   % ncwrite(filename,'adatrj',adatrj);

    nccreate(filename,'ntime', 'Dimensions',{'t',Inf},'Datatype','double')
    ncwrite(filename,'ntime',ntime);

   % nccreate(filename,'rdt', 'Dimensions',{'t',Inf},'Datatype','double')
   % ncwrite(filename,'rdt',rdt);

    nccreate(filename,'e3t_b', 'Dimensions',{'x',x,'y',y,'z',z,'t',Inf},'Datatype','double')
    ncwrite(filename,'e3t_b',e3t_new);

    nccreate(filename,'e3t_n', 'Dimensions',{'x',x,'y',y,'z',z,'t',Inf},'Datatype','double')
    ncwrite(filename,'e3t_n',e3t_new);
end

field_3D
nccreate(filename,field_3D, 'Dimensions',{'x',x,'y',y,'z',z,'t',Inf},'Datatype','double')
ncwrite(filename,field_3D,Temp_out);

end

