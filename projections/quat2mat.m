function [R,dRdQ] = quat2mat(Q)
% QUAT2MAT - Convert a quaternion to a 3x3 rotation matrix
%   

q0 = Q(1); q1 = Q(2); q2 = Q(3); q3 = Q(4);
R = [q0^2+q1^2-q2^2-q3^2, 2*(q1*q2-q0*q3), 2*(q1*q3+q0*q2); ...
     2*(q1*q2+q0*q3), q0^2+q2^2-q1^2-q3^2, 2*(q2*q3-q0*q1); ...
     2*(q1*q3-q0*q2), 2*(q2*q3+q0*q1), q0^2+q3^2-q1^2-q2^2];
