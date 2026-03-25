function [Data] = Fun_AttitudeCompensation(Data,Par)

%姿态补偿
%输入：Data  用于训练的数据  
%num  选择光泵数据  num = 1 光泵1   num = 2 光泵2    num = 3   差分 
%Par  补偿系数
%输出：Data


%数据读取

B = Data(:,9);%磁传感器磁测的磁感应强度B，单位为特斯拉。


Fx = Data(:,11);%读取第11列数据（磁通门传感器X轴的磁场强度）
Fy = Data(:,12);%读取第12列数据（磁通门传感器Y轴的磁场强度）
Fz = Data(:,13);%读取第11列数据（磁通门传感器Z轴的磁场强度）

num = length(B);
H = B;%磁感应强度与磁场强度H的关系为：H=μB，μ为磁导率。

Hm = H;%光泵1实测磁场强度。

U = zeros(num, 8);%创建n*8的0矩阵
Um = zeros(num, 8);%创建n*8的0矩阵
u = zeros(8, 1);%创建一个 8 行 1 列的零矩阵，并将其赋值给变量 u
for k = 1 : num
    
    ii = k ;%将循环变量K赋值给GeoVect函数变量
    [cthx, cthy, cthz] = GeoVect(Fx(ii), Fy(ii), Fz(ii));%获取磁通门传感器实测三分量的余弦值
    
    %余弦方向矩阵中为降低求解维度，消除相等项和耦合关系以及全微分项，由21项地磁余弦系数减少为16项。其中固有场3项，感应场5项，涡流场8项。忽略涡流项后只需求解8项系数。如下：
    u(1) = cthx;%8行1列中1行1列的数据，以下类似。
    u(2) = cthy;
    u(3) = cthz;
    u(4) = cthx^2;
    u(5) = cthy^2;
    u(6) = cthx * cthy;
    u(7) = cthx * cthz;
    u(8) = cthy * cthz;
     
    U(k,:) = u;%将向量 u 的值赋给矩阵 U 的第 k 行，：表示所有列。即将每组每行的8项地磁余弦方向系数存储到矩阵U中。
    Um(k,:) = Hm(k) * u;%用光泵1测得磁场总值乘以余弦值得到各分量。
    
    
end

Hp = Um * Par;% Um是用光泵1测得磁场总值乘以余弦值得到的各分量，再乘以x（par）解向量。
Bp = (H - Hp);%实测值-每一个求解值，得到差


Data(:,9) = Bp;
end