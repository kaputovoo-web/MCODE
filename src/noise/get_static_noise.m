function result = get_static_noise(mag, fs, ratio)

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

%% 静态噪声 
B_static = five_diff(y, 16);
Sn_static = std(B_static);

B_static_r = five_diff(y1, 16);
Sn_static_r = std(B_static_r);

result = struct();

result.static.std   = Sn_static;
result.static.file_std = Sn_static_r;

end
