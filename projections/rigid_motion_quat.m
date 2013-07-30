% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation, version 2.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software Foundation,
% Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                 %
%   Created : 2005                                %
%    Author : Christopher Mei                     %
%                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Y,dYdQ,dYdT] = rigid_motion_quat(X,Q,T);  %rigid_motion transform
% rigid_motion_quat.m
%
% Y = rigid_motion_quat(X,Q,T)
%
% Computes the rigid motion transformation Y = R*X+T, where R = quat2mat(Q/norm(Q)).
%
% INPUT: X: 3D structure in the world coordinate frame (3xN matrix for N points)
%       (Q,T): Rigid motion parameters between two frames
%                 Q: rotation quaternion (4x1 vector); T: translation vector (3x1 vector)
%
% OUTPUT: Y: 3D coordinates of the structure points in the new reference frame (3xN matrix for N points)
%         dYdQ : jacobian of Y with respect to Q.
%         dYdT : jacobian of Y with respect to T.
%
% Definitions:
% Let P be a point in 3D of coordinates X in the world reference frame (stored in the matrix X)
% The coordinate vector of P in the camera reference frame is: Y = R*X + T
% where R is the rotation matrix corresponding to the quaternion Q : R = quat2mat(Q);
%
% Important function called within that program:
%
% quat2mat.m: Computes the rotation matrix corresponding to a quaternion
%

if nargin < 3,
  T = zeros(3,1);
  if nargin < 2,
    q = [1;zeros(3,1)];
    if nargin < 1,
      disp('Launching test...');
      test
      return;
    end;
  end;
end;

switch nargout
 case 0
 case 1
  Y=transform(X,Q/norm(Q),T);
 case 2
  [nQ,dnQdQ] = normQuat(Q);
  dRdnQ = jacobianQuatFull(X,nQ);
  dYdQ = dRdnQ*dnQdQ;
  Y=transform(X,nQ,T);
 case 3
  [nQ,dnQdQ] = normQuat(Q);
  
  Y=transform(X,nQ,T);
  
  dYdnQ = jacobianQuatFull(X,nQ);
  dYdQ = dYdnQ*dnQdQ;
    
  dYdT=repmat(eye(3),[size(X,2) 1]);
 otherwise
  disp('Too many output args.')
end

function test
X=randn(3,2);

error=1e-4;
disp(['Error : ' num2str(error)]);

Q = randn(4,1);
dQ = randn(4,1)*error;

%%% Test without normalising %%%
Qp=Q+dQ;
n=size(X,2);

Y1=quat2mat(Q)*X;
Y2=quat2mat(Qp)*X;
Y1=reshape(Y1,3*n,1);
Y2=reshape(Y2,3*n,1);

dYdnQ = jacobianQuatFull(X,Q);

errorY=norm(Y2-Y1-dYdnQ*dQ);

disp(['Estimate error without normalising : ' num2str(errorY)]);

%%% Test normalising %%%
Qp=Q+dQ;
n=size(X,2);
[Y1,dYdQ]=rigid_motion_quat(X,Q);
Y2=rigid_motion_quat(X,Qp);

Y1=reshape(Y1,3*n,1);
Y2=reshape(Y2,3*n,1);

errorY=norm(Y2-Y1-dYdQ*dQ);

disp(['Estimate error normalising : ' num2str(errorY)]);

%%% Full test  %%%
V=randn(7,1);
dV=randn(7,1)*error;
%V=[1;zeros(3,1);10*ones(3,1)];
%dV=V*error;
Vp=V+dV;

[Y,dYdQ,dYdT]=rigid_motion_quat(X,V(1:4),V(5:7));
dYdV=[dYdQ dYdT];

Yp=rigid_motion_quat(X,Vp(1:4),Vp(5:7));

Y=reshape(Y,3*n,1);
Yp=reshape(Yp,3*n,1);

errorY=norm(Yp-Y-dYdV*dV);

disp(['Estimate error (full test) normalising : ' num2str(errorY)]);

function Y=transform(X,Q,T)
R = quat2mat(Q);
n = size(X,2);

Y = R*X + repmat(T,[1 n]);

function dYdQ=jacobianQuatFull(X,Q)
n = size(X,2);
dYdQ=zeros(3*n,4);

for i=1:n
  dYdQ(3*(i-1)+1:3*i,:)=jacobianQuat(X(:,i),Q);
end


function dYdQ=jacobianQuat(X,Q)
q0=Q(1); q1=Q(2); q2=Q(3); q3=Q(4);
x=X(1); y=X(2); z=X(3);

dYdQ = 2*[[q0*x-q3*y+q2*z;...
	   q3*x+q0*y-q1*z;...	   
	   -q2*x+q1*y+q0*z],...	   ,...
	  ...
	  [q1*x+q2*y+q3*z;...
	   q2*x-q1*y-q0*z;...
	   q3*x+q0*y-q1*z],...     
	  ...
	  [-q2*x+q1*y+q0*z;...
	   q1*x+q2*y+q3*z;...
	   -q0*x+q3*y-q2*z],...
	  ...
	  [-q3*x-q0*y+q1*z;...
	   q0*x-q3*y+q2*z;...
	   q1*x+q2*y+q3*z]];
	
function [nQ,dnQdQ] = normQuat(Q)
normQ=norm(Q);
nQ=Q/normQ;
q0=Q(1); q1=Q(2); q2=Q(3); q3=Q(4);

dnQdQ = [[q1^2+q2^2+q3^2;...
	  -q0*q1;...
	  -q0*q2;...
	  -q0*q3],...
	 ...
	 [-q0*q1;...
	  q0^2+q2^2+q3^2;...
	  -q1*q2;...
	  -q1*q3],...
	 ...
	 [-q0*q2;...
	  -q1*q2;...
	  q0^2+q1^2+q3^2;...
	  -q2*q3],...
	 ...
	 [-q0*q3;...
	  -q1*q3;...
	  -q2*q3;...
	  q0^2+q1^2+q2^2]]/normQ^3;
	 
