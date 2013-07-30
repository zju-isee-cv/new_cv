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
%     Calculates the camera projection function   %
%               and its jacobian                  %
%                                                 %
%   Created : 2005                                %
%    Author : Christopher Mei                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [P,dPdV] = omniCamProjection(X, V)  %reprojection, this is important

if nargin==0
  disp('Launching test...');
  test;
  return
end

switch nargout
 case 0
 case 1
  P = transform(X, V);
 case 2
  [P,dPdV] = transformFull(X, V);
 otherwise
  disp('Too many output args.')
end

function P = transform(X, V, bounded_xi) %V is Q T xi kc alpha_c gammac cc

P = rigid_motion_quat(X, V(1:4), V(5:7));
P = spaceToNPlane(P,V(8));
P = distortion(P, V(9:13));
P = NPlaneToImgPlane(P, V(14:18));

function [P,dPdV] = transformFull(X, V, bounded_xi)
[P,dWdQ,dWdT] = rigid_motion_quat(X, V(1:4), V(5:7));
dWdV1 = [dWdQ dWdT];
[P,dHdW,dHdsxi] = spaceToNPlane(P, V(8));
[P,dDdV2,dDdH] = distortion(P, V(9:13));
[P,dPdV3,dPdD] = NPlaneToImgPlane(P, V(14:18));

nb = size(X,2);
dPdV = zeros(2*nb,18);

for i=1:nb
  inter=2*(i-1)+1:2*i;
  dPdV(inter,:)=[dPdD(inter,:)*[dDdH(inter,:)*[dHdW(inter,:)* ...
		    dWdV1(3*(i-1)+1:3*i,:) dHdsxi(inter,:)] dDdV2(inter,:)] dPdV3(inter,:)];
end

function s = slog10(val)
s = num2str(floor(log10(val)));


%not important
function test
error=1e-4;
disp(['Error : 1e' slog10(error)]);

%%% Values %%%
X=randn(3,4);

V=randn(18,1);
dV=randn(18,1)*error;

[P,dPdV] = omniCamProjection(X,V);

Pp = omniCamProjection(X,V+dV);

dP = dPdV*dV;

nb = size(X,2);
Pp = reshape(Pp,2*nb,1);
P = reshape(P,2*nb,1);

gainP = norm(Pp-P)/norm(Pp-P-dP);

disp(['Estimate gain in X : 1e' slog10(gainP)]);
