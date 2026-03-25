clc;
close all;
clear all;

%% 探测数据导入
DetectionFilename = ('梳字.txt');
Data = load(DetectionFilename);

%% 日变数据导入
BaseFilename = ('日变站20241010.txt');
BaseData = load(BaseFilename);

%% 日变校正
DetectionTime = Data(:,3); %将机载设备数据第3列提取到数组中
DetectionMagnetic = Data(:,9);%将数据第9列，光泵1实测数据
BaseTime = BaseData(:,3);%将时变基站设备的时间提取
BaseMagnetic = BaseData(:,7);%将时变基站设备的磁感应强度提取

[ProcessedMagnetic] = Fun_DailyCorrection(DetectionTime,DetectionMagnetic,BaseTime,BaseMagnetic);

%% 绘制结果
fig = figure('Position', [500, 200, 800, 300]); % 设置画布的左下角位置为 (100, 100)，宽度为 800，高度为 600
% 上方的图
plot(DetectionMagnetic,'LineWidth',1,"DisplayName","原始");
hold on;
plot(ProcessedMagnetic,'LineWidth',1,"DisplayName","校正");
legend;
xlabel('Time(s)', 'FontSize', 20); % 设置 x 轴标签名称
ylabel('B(nT)', 'FontSize', 20); % 设置 y 轴标签名称
set(gca, 'FontSize', 16); % 设置坐标轴刻度的字号为12
grid minor;
box on;

%%
Data(:,9) = ProcessedMagnetic;

% 姿态补偿
[Par] = Fun_AttitudeTrain(Data);%光泵1乘以磁通门三轴余弦值经线性拟合求得解向量
[Data2] = Fun_AttitudeCompensation(Data,Par);

%% 绘制结果
fig = figure('Position', [500, 200, 800, 300]); % 设置画布的左下角位置为 (100, 100)，宽度为 800，高度为 600
% 上方的图
plot((1:length(Data(:,9)))/10,Data(:,9) - mean(Data(:,9)),'LineWidth',1,"DisplayName","日变校正");
hold on;
plot((1:length(Data2(:,9)))/10,Data2(:,9) - mean(Data2(:,9)),'LineWidth',1,"DisplayName","姿态补偿");
legend;
xlabel('Time(s)', 'FontSize', 20); % 设置 x 轴标签名称
ylabel('B(nT)', 'FontSize', 20); % 设置 y 轴标签名称
set(gca, 'FontSize', 16); % 设置坐标轴刻度的字号为16
grid minor;
box on;
%xlim([0 40]);

save Par Par;
