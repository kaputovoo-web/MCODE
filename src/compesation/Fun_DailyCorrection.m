function [ProcessedMagnetic] = Fun_DailyCorrection(DetectionTime,DetectionMagnetic,BaseTime,BaseMagnetic)

%输入参数
%DetectionTime      探测数据时间
%时间格式           GPS时间 格林尼治时分秒.f
%DetectionMagnetic  探测数据磁场
%BaseTime           基站数据时间
%BaseMagnetic       基站数据磁场

%输出参数
%ProcessedMagnetic  日变校正后磁场数据

% 初始化最接近行的索引和无效状态计数器
closest_row_idx = zeros(size(DetectionTime));

% 遍历 DetectionTime 中的每一行
for i = 1:length(DetectionTime) %生成一个行向量，从 1 开始，到 DetectionTime 的长度结束（包含这个值）
    % 计算当前 DetectionTime 行与所有 BaseTime 行的时间差的绝对值
    time_diff = abs(DetectionTime(i) - BaseTime);

    % 找到时间差绝对值的最小值对应的索引
    [~, min_idx] = min(time_diff); %min 函数返回两个输出：第一个输出是 time_diff 的最小值，第二个输出是最小值的索引
    closest_row_idx(i) = min_idx;%将当前迭代中找到的最小值的索引（min_idx）存储到 closest_row_idx 数组的第 i 个位置
    ProcessedMagnetic(i) = DetectionMagnetic(i) - mean(DetectionMagnetic) - (BaseMagnetic(closest_row_idx(i)) - mean(BaseMagnetic)) + 54643;
    %计算的是第 i 个元素与该数组均值的差值。这可以用来衡量该元素相对于整体均值的偏差。54643怎么来的？这是将两天的数据取平均值得到的。
    DailyData(i) =  BaseMagnetic(closest_row_idx(i));%找到时间一致的起始日变磁场强度

end

end