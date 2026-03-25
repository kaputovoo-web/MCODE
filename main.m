clc;clear all;close all;
addpath(genpath("src"));data=struct();
%% 00 loaddata & config 
raw=readdata('E:\00experiment\DataProcess\00实地探测_Data\FD20260318\20260318FD.txt');

dataDC=readDC("E:\00experiment\DataProcess\00实地探测_Data\FD20260318\mag_202603181345_202603181520.txt");

%% paraments setting
config = struct();
config.respath='E:\00experiment\DataProcess\FD_code\res\FD01';

config.fs = 20;    % 0.05s
config.radio = config.fs/2; %resample 10 point --> 0.5s

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
config.exptime.total=[134740 144358];

% figure
config.fig.fontName   = 'Times New Roman';
config.fig.fontSize   = 20;
config.fig.labelSize  = 26;
config.fig.legendSize = 20;

config.fig.lineWidth  = 3;

config.fig.colorOrder = [
    0.0000    0.4470    0.7410   % 蓝
    0.8500    0.3250    0.0980   % 橙
    0.9290    0.6940    0.1250   % 黄
    0.4940    0.1840    0.5560   % 紫
    0.4660    0.6740    0.1880   % 绿
    0.3010    0.7450    0.9330   % 青
    0.6350    0.0780    0.1840   % 红
];


% config.fig.width  = 12;   
% config.fig.height = 6;    

config.fig.type = 'single'; % 'single' / 'double'

config.fig.dpi = 300;
%% 00 loaddata & config END

%% 01 Data segmentation or experimental data separation
BDS=raw(:,1);
data.exptime_fields = fieldnames(config.exptime);
% raw data clip
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
    data.(field_name).DC=dataDC.DCop(index);
end

% DC data clip

clear file_path field_name raw time_range BDS i index;
%% 01 Data segmentation or experimental data separation end

%% 02 Data Progess

%  001 静态噪声
% figure;
% plot(data.static_noise1.time, ...
%      data.static_noise1.op2, ...
%      'LineWidth', config.fig.lineWidth, ...
%      'DisplayName', 'RAW B');
% grid on; hold on; box on;
% xlabel('Time (s)', 'FontSize', config.fig.labelSize,'FontWeight','Bold');
% ylabel('B (nT)', 'FontSize', config.fig.labelSize,'FontWeight','Bold');
% legend('show', ...
%     'Location', 'best', ...
%     'FontSize', config.fig.legendSize,'FontWeight','Bold');
% createFigure(config.fig);

fprintf('⭐Static noise 001\n');
config.respath='E:\00experiment\DataProcess\FD_code\res\FD01\static';
res.static=fig_static(data.static_noise1,config);
title('Static', 'FontSize', config.fig.labelSize,'FontWeight','Bold');

% 002 动态噪声
fprintf('⭐Dynamic noise 001\n');
config.respath='E:\00experiment\DataProcess\FD_code\res\FD01\dynamic01';
res.dynamic01=fig_dynamic(data.dynamic_noise1,config);
title('Dynamic EXP01', 'FontSize', config.fig.labelSize,'FontWeight','Bold');

fprintf('⭐Dynamic noise 002\n');
config.respath='E:\00experiment\DataProcess\FD_code\res\FD01\dynamic02';
res.dynamic02=fig_dynamic(data.dynamic_noise2,config);
title('Dynamic', 'FontSize', config.fig.labelSize,'FontWeight','Bold');


