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
%     Calculates the distance between two         %
%       projected points and the jacobian         %
%                                                 %
%   Created : 2005                                %
%    Author : Christopher Mei                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [S,dSdV] = sphericalDistanceProjection(X, Xp, V, xi, eta)

if nargin==0
  disp('Launching test...');
  test;
  return
end

switch nargout
 case 0
 case 1
  S=distance(X, Xp, V, xi, eta);
 case 2
  [S,dSdV]=distanceFull(X, Xp, V, xi, eta);
 otherwise
  disp('Too many output args.')
end

function test
error=1e-4;
disp(['Error : 1e' slog10(error)]);

%%% Values %%%
X=randn(3,4);
Xp=randn(3,4);

V=randn(17,1);
%dV=randn(17,1)*error;
%dV=[zeros(17,1)] %randn(0,1)*error];
dV=[randn(17,1)*error];

p=1;
d=NaN;
type=1;
[xi,phi]=pd2xiphi(p,d,type);
eta = xi-phi;

[S,dSdV]=sphericalDistanceProjection(X,Xp,V,xi,eta);
[S2,dSdV]=sphericalDistanceProjection(X,Xp,V,xi,eta);

Sp=sphericalDistanceProjection(X,Xp,V+dV,xi,eta);

dS=dSdV*dV;

nb=size(X,2);
Sp=reshape(Sp,nb,1);
S=reshape(S,nb,1);

gainP=norm(Sp-S)/norm(Sp-S-dS);

disp(['Estimate gain in V : 1e' slog10(gainP)]);

% X : world points
% Xp : image points
function S=distance(X, Xp, V, xi, eta)

PX=rigid_motion_quat(X, V(1:4), V(5:7));
PX=norm3DVector(PX);

PXp=pointProjection(Xp, V(13:17));
PXp=distortion(PXp, V(8:12));
PXp(1:2,:)=PXp(1:2,:)/eta;
PXp=pointLifting(PXp,xi);

S=arccos(scalarProduct(PX,PXp));

function [S,dSdV]=distanceFull(X, Xp, V, xi, eta)
%Right side of the derivation
[PX,dWdQ,dWdT]=rigid_motion_quat(X, V(1:4), V(5:7));
dWdV1=[dWdQ dWdT];
[PX,dNdW]=norm3DVector(PX);

%Left side
[PXp,dPdV3]=pointProjection(Xp, V(13:17));
[PXp,dDdV2,dDdP]=distortion(PXp, V(8:12));
PXp(1:2)=PXp(1:2)/eta;
[PXp,dHdD]=pointLifting(PXp,xi);
dHdD=dHdD/eta;

[S,dhdN,dhdH]=scalarProduct(PX,PXp);
[S,dSdh]=arccos(S);

% $$$ sdPdD=size(dPdD)
% $$$ sdDdH=size(dDdH)
% $$$ sdHdW=size(dHdW)
% $$$ sdWdV1=size(dWdV1)
% $$$ sdDdV2=size(dDdV2)
% $$$ sdPdV3=size(dPdV3)
% size(dHdD)
% size(dhdH)
% sdNdW=size(dNdW)

nb=size(X,2);
dSdV=zeros(nb,17);

for i=1:nb
  inter2=2*(i-1)+1:2*i;
  inter3=3*(i-1)+1:3*i;
  dSdV(i,:)=dSdh(i,:)*[dhdN(i,:)*dNdW(inter3,:)*dWdV1(inter3,:) dhdH(i,:)*dHdD(inter3,:)*[dDdV2(inter2,:) ...
		    dDdP(inter2,:)*dPdV3(inter2,:)]];
end

function dPdV = jacobianVProjectionFull(X,alpha,f1,f2,c1,c2)
[m,n] = size(X);
dPdV=zeros(2*n,5);

for i=1:n
  dPdV(2*(i-1)+1:2*i,:)=jacobianVProjection(X(:,i),alpha,f1,f2,c1,c2);
end

function dPdX = jacobianXProjectionFull(X,alpha,f1,f2,c1,c2)
[m,n] = size(X);
dPdX=zeros(2*n,2);

for i=1:n
  dPdX(2*(i-1)+1:2*i,:)=jacobianXProjection(X(:,i),alpha,f1,f2,c1,c2);
end

function dPdV = jacobianVProjection(X,alpha,f1,f2,c1,c2)
x=X(1); y=X(2);

dPdV=[f1*y,x+alpha*y,0,1,0;
      0,0,y,0,1];

function dPdX = jacobianXProjection(X,alpha,f1,f2,c1,c2)
dPdX=[f1,f1*alpha;
      0,f2];

function s=slog10(val)
s=num2str(floor(log10(val)));
