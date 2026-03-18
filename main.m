clc;clear all;close all;
addpath("src");
[raw, file_path]=readdata('E:\00experiment\DataProcess\00实地探测_Data\FD20260318\20260318FD.txt');
%% paraments setting
config = struct();
config.fs = 20;
config.exptime.static_noise1=[134740 135240];
config.exptime.dynamic_noise1=[140927 141023];
config.exptime.dynamic_noise2=[141255 141344];
config.exptime.spin=[141543 141751];
config.exptime.hover=[141930 142336];
config.exptime.ct=[143338 143917];
config.exptime.same_line=[144248 144358];
config.exptime.inter_line=[150836 151000];
config.exptime.night_dynamic_noise1=[151313 151454];
config.exptime.night_dynamic_noise2=[151638 151818];
%% paraments end
%% Data segmentation or experimental data separation
data=struct();BDS=raw(:,1);
data.exptime_fields = fieldnames(config.exptime);
for i = 1:length(data.exptime_fields)
    field_name = data.exptime_fields{i};
    time_range = config.exptime.(field_name);
    index = find(BDS >= time_range(1) & BDS <= time_range(2));
    if ~isempty(index)
        data.(field_name) = raw(index,:);
        data.(field_name) = redata(data.(field_name), config);
    else
        disp(['Warnning：', field_name, ' No data within the time range！']);
        data.(field_name) = [];
    end
end

%% Data segmentation or experimental data separation end
