function y=Q(x)
% co-error function: 1/sqrt(2*pi) * int_x^inf exp(-t^2/2) dt.|误差函数
y=erfc(x/sqrt(2))/2;