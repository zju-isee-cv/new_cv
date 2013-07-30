function q = mat2quat(R)
% MAT2QUAT - Convert a 3x3 rotation matrix to a quaternion
%

q=[0.5*sqrt(1+R(1,1)+R(2,2)+R(3,3));
   0.5*sqrt(1+R(1,1)-R(2,2)-R(3,3))*sgn(R(3,2)-R(2,3));
   0.5*sqrt(1-R(1,1)+R(2,2)-R(3,3))*sgn(R(1,3)-R(3,1));
   0.5*sqrt(1-R(1,1)-R(2,2)+R(3,3))*sgn(R(2,1)-R(1,2))];
