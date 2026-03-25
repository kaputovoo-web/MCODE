function [cthx, cthy, cthz] = GeoVect(fx, fy, fz)
%GeoVect 是一个函数，它接受三个输入参数 fx、fy 和 fz，并返回三个输出参数 cthx、cthy 和 cthz
fm = sqrt(fx^2 + fy^2 + fz^2);%求模值
cthx = fx/fm;%X轴与矢量之间夹角的余弦值。
cthy = fy/fm;
cthz = fz/fm;
end