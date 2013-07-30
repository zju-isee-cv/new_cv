% a = zeros(1,9);
% 
% for i = 1: 1000000
%     x = rand;
%     y = rand;
%     z = x / y;
%     while(z >= 10)
%         z = z / 10;
%     end
%     while(z < 1)
%         z = z * 10;
%     end
%     p = floor(z);
%     a(p) = a(p) + 1;
% end
% 
% a / sum(a)
%     

% sum = 0;
% for i = -100000 : 100000
%     sum = sum + atan(2 * 10 ^ i) -atan(1*10^i);
% end
% sum * 180 / pi
syms x
simple(atan(2*x) - atan(x))