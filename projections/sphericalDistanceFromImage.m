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
%    Calculates the spherical distance between    %
%          two points in the image                %
%                                                 %
%   Created : 2005                                %
%    Author : Christopher Mei                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% K contains the calibration values
% K=[sxi;k1;k2;k3;k4;k5;alpha;f1;f2;c1;c2]
%
function D = sphericalDistanceFromImage(X, Y, K);

if nargin==0
  disp('Launching test...');
  test;
  return
end

PX=fullLifting(X, K);
PY=fullLifting(Y, K);
D=zeros(1,size(PX,2));

for i=1:size(PX,2)
  D(i)=sphericalDistance(PX(:,i),PY(:,i));
end

function test
%%% Values %%%
X1=[1;0];
X2=[2;0];
X3=[2000;0];
X4=[2001;0];

%X3=[5;5];
%X4=[5+sqrt(2)/2;5+sqrt(2)/2];
Dist_euclidien1=norm(X1-X2)
Dist_euclidien2=norm(X3-X4)

K=zeros(5,1);
alpha=0;
F=[17;18];
C=[0;0];


p=16.7;
d=3;
type=1;
[xi,phi]=pd2xiphi(p,d,type);
eta = xi-phi;

K=[K;alpha;F*eta;C];

% $$$ P1=fullLifting(X1,K,p,d,type);
% $$$ error1=norm(omniCamProjection(P1, [1;zeros(6,1);K], p, d, type)-X1);
% $$$ P2=fullLifting(X2,K,p,d,type);
% $$$ error2=norm(omniCamProjection(P2, [1;zeros(6,1);K], p, d, type)-X2);
% $$$ P3=fullLifting(X3,K,p,d,type);
% $$$ error3=norm(omniCamProjection(P3, [1;zeros(6,1);K], p, d, type)- ...
% $$$ 	    X3);
% $$$ P4=fullLifting(X4,K,p,d,type);
% $$$ error4=norm(omniCamProjection(P4, [1;zeros(6,1);K], p, d, type)- ...
% $$$ 	    X4);
% $$$ 
% $$$ error=(error1+error2+error3+error4)/3
% $$$ 
% $$$ D1=sphericalDistance(P1,P2)
% $$$ D2=sphericalDistance(P3,P4)

D1=sphericalDistanceFromImage(X1, X2, K);
D2=sphericalDistanceFromImage(X3, X4, K);

