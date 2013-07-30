%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                       %
%   Extract grid corners manually                       %
%                                                       %
%   Created : 2012 (mod 13/07/06)                       %
%   Author : Zhejiang Provincial Key Laboratory of      %
%                Information Network Technology         %
%                      Zhejiang University              %
%                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Q, T, R] = estimate_RT(X, x, cc, gamma)
% ima_number = 2;
% X = gridInfo.X{ima_number};
% x = gridInfo.x{ima_number};
% gamma = paramEst.gammac(1);
Mx = [];
for i = 1 : size(x,2)
    uc = x(1,i) - cc(1);
    vc = x(2,i) - cc(2);
    Xw = X(1,i);
    Yw = X(2,i);
    MxL = [vc*Xw, vc*Yw, vc, -uc*Xw, -uc*Yw, -uc];
    Mx = [Mx;MxL];
end
A = Mx(:,1:5);
B = -Mx(:,6);
lambda = linsolve(A,B);

lambda11 = lambda(1);
lambda12 = lambda(2);
lambda1 = lambda(3);
lambda21 = lambda(4);
lambda22 = lambda(5);
lambda2 = 1;
Mx2 = [];
for i = 1 : size(x,2)
    uc = x(1,i) - cc(1);
    vc = x(2,i) - cc(2);
    Xw = X(1,i);
    Yw = X(2,i);
    S = gamma/2 - (uc^2+vc^2)/2/gamma;
    MxL1 = [uc*Xw, uc*Yw, uc, -S*(Xw*lambda11+Yw*lambda12+lambda1)];
    MxL2 = [vc*Xw, vc*Yw, vc, -S*(Xw*lambda21+Yw*lambda22+1)];
    Mx2 = [Mx2;MxL1;MxL2];
end
A = Mx2(:,1:3);   
B = -Mx2(:,4);
lambda = linsolve(A, B);
lambda31 = lambda(1);
lambda32 = lambda(2);
lambda3 = lambda(3);

t21 = sqrt(1/(lambda11^2+lambda21^2+lambda31^2));
t22 = sqrt(1/(lambda12^2+lambda22^2+lambda32^2));
t2 = sqrt(t21*t22);
if(lambda3*t2 < 0)
    t2 = -t2;
end
t1 = lambda1*t2;
r11 = lambda11*t2;
r12 = lambda12*t2;
r21 = lambda21*t2;
r22 = lambda22*t2;
t3 = lambda3*t2;
r31 = lambda31*t2;
r32 = lambda32*t2;
T = [t1;t2;t3];%T
rcol1 = [r11;r21;r31];
rcol1 = rcol1/norm(rcol1);
rcol2 = [r12;r22;r32];
rcol2 = rcol2/norm(rcol2);
rcol3 = cross(rcol1,rcol2);
R_est = [rcol1, rcol2, rcol3];
[U,S,V] = svd(R_est);
R = U*eye(3)*V';%R

t = acos((R(1,1)+R(2,2)+R(3,3) - 1)/ 2);
w = [(R(3,2)-R(2,3)),(R(1,3)-R(3,1)),(R(2,1)-R(1,2))]/2/sin(t);
Q = [cos(t/2);sin(t/2)*w(1);sin(t/2)*w(2);sin(t/2)*w(3)];%Q
