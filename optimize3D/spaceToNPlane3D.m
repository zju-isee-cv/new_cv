function [P,dPdX,dPdxi] = spaceToNPlane3D(X, Q, Xi3D)  %space to normal plane with focal point can move in three directions

switch nargout
 case 0
 case 1
  P=transform(X,Q, Xi3D);
 case 2
 case 3
   disp('not finished yet');
 otherwise
  disp('Too many output args.')
end

function P=transform(X, Q, Xi3D)

r = sqrt(X(1,:).^2 + X(2,:).^2 + X(3,:).^2);
Xs = X./(ones(3,1)*r);
Q = Q / norm(Q);
R = quat2mat(Q);
Xst = R * Xs + Xi3D*ones(1, size(Xs,2));
P = Xst(1:2,:)./(ones(2,1)*Xst(3,:)); 