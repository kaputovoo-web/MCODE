function [Par] = Fun_AttitudeTrain(Data)

%姿态训练
%输入：Data  用于训练的数据  
%选择光泵数据  num = 1 光泵1   num = 2 光泵2    num = 3   差分 
%输出：Par  补偿系数

%数据读取


B = Data(:,9);%磁传感器磁测的磁感应强度B，单位为特斯拉。

Fx = Data(:,11);%读取第11列数据（磁通门传感器X轴的磁场强度）
Fy = Data(:,12);%读取第12列数据（磁通门传感器Y轴的磁场强度）
Fz = Data(:,13);%读取第11列数据（磁通门传感器Z轴的磁场强度）

%方向系数构建
Hd = B - mean(B);%用光泵1的磁测数据减去平均值得到差值
Hm = B;%光泵1的磁测数据
num = length(Hm);%光泵1采集数据长度
U = zeros(num, 8);%创建n*8的0矩阵
Um = zeros(num, 8);%创建n*8的0矩阵

u = zeros(8, 1);%创建一个 8 行 1 列的零矩阵，并将其赋值给变量 u

for k = 1 : num
    
    ii = k;
    
    [cthx, cthy, cthz] = GeoVect(Fx(ii), Fy(ii), Fz(ii));
    
    u(1) = cthx;
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
%Um是稀疏矩阵或线性算子，代表方程组的系数矩阵；Hd代表方程组的右侧差值（实测值-平均基值）常数列向量，[]表示没有提供初始猜测值，函数将使用默认值（通常是零向量）；
%100 是指定的最大迭代次数，意味着 lsqr 在查找解的过程中最多进行100次迭代。
Par = lsqr( Um ,Hd,[],100);%x = lsqr(A, b)，求解出x解向量

end

