clc;
clear;
close all;

function [TS_1,TS_2,TS_3] = S (fai)%定义一个函数，得到目标强度和方位角度的关系

a1 = 20;
b1 = 5;
x0 = 10;
%%%
a = 30;
b = 8;
y0 = 5;
%%%
x1 = 10;
x2 = -50;
h = 5;
%%%
a2 = 3;
b2 = 1;
L = 2.5;
%%%
a3 = 1.5;
b3 = 0.2;
x3 = -45;
%%%
c = 1480;
f = 10^4;
V = c/f;%波长
k = (2*pi)/V;%波数

u0 = atan( (b1 * tan(fai))/a1 );
aa1 = a1 * cos(u0) * cos(fai) + b1 * sin(u0) * sin(fai) + x0 * cos(fai);
H1 = (a1^2 * sin(u0)^2 + b1^2 * cos(u0)^2)/(2 * a1) * exp(-2i*k*aa1); 

u1 = atan( (b * tan(fai))/a );
aa2 = a1 * cos(u1) * cos(fai) + b1 * sin(u1) * sin(fai) + y0 * sin(fai);
H2 = 0.5 * sqrt( (b * sin(u1) - y0)/(a * b * sin(fai)) ) *(a^2 * sin(u1)^2 + b^2 * cos(u1)^2)^(3/4) * exp(-2i * k * aa2);

aa3 = (a2 * cos(fai))^2 + (b2 * sin(fai))^2;
H3 = sqrt(k/pi) * (h * a2 * b2)/(2 * aa3^(3/4)) * exp(-2i * k * sqrt(aa3));

aa4 = (a3 * cos(fai))^2 + (b3 * sin(fai))^2;
H4 = 2 * sqrt(k/pi) * (L * a3 * b3)/(2 * aa4^(3/4)) * exp(-2i * k * (aa4 + x3 * cos(fai)));

TS_1 = 10 * log10((abs(H1))^2 + (abs(H3))^2);

TS_2 = 10 * log10((abs(H2))^2 + (abs(H3))^2 + (abs(H4))^2);

TS_3 = 10 * log10((abs(H3))^2 + (abs(H4))^2);

end
%%%
data_1 = [];
data_2 = [];
data_3 = [];
data_4 = [];
data_5 = [];
data_6= [];

for i = 0:pi/180:88*pi/180  
    [TS_1,TS_2,TS_3] = S (i);
   data_1(end + 1) = TS_1; 
  
end

for i = 88*pi/180:pi/180:105.6*pi/180  
    [TS_1,TS_2,TS_3] = S (i);
    data_2(end + 1) = TS_2;
   
end 

for i = 105.6*pi/180:pi/180:pi  
    [TS_1,TS_2,TS_3] = S (i);
    data_3(end + 1) = TS_3;
    
end 

i1 = 0:pi/180:88*pi/180;
i2 = 88*pi/180:pi/180:105.6*pi/180;
i3 = 105.6*pi/180:pi/180:180*pi/180;
i4 = 180*pi/180:pi/180:254.4*pi/180;
i5 = 254.4*pi/180:pi/180 :272*pi/180;
i6 = 272*pi/180:pi/180:360*pi/180;

data_4 = flip(data_1);
data_5 = flip(data_2);
data_6 = flip(data_3);
angles = [i1,i2,i3,i4,i5,i6];  
intensity = [data_1,data_2,data_3,data_6,data_5,data_4]; 

%figure; 
polarplot(angles, intensity, 'r', 'LineWidth', 1);
grid on;    