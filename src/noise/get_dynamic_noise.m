function result = get_dynamic_noise(mag, fs, ratio)

mag = mag(:);                         
mag_demean = remean(mag);         
% 抽点
y = mag(1:ratio:end);

% resample（带抗混叠滤波）
y1 = resample(mag_demean, fs/ratio, fs);

five_diff = @(x, scale) ...
    arrayfun(@(i) ...
    (x(i-2)-4*x(i-1)+6*x(i)-4*x(i+1)+x(i+2)) / scale, ...
    3:length(x)-2)';

B_dynamic = five_diff(y, 1);
Sn_dynamic = std(B_dynamic) / sqrt(70);

B_dynamic_r = five_diff(y1, 1);
Sn_dynamic_r = std(B_dynamic_r) / sqrt(70);


result = struct();

result.dynamic.std   = Sn_dynamic;
result.dynamic.file_std = Sn_dynamic_r ;

end
