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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Point lifting (unified projection model   %
%         for omnidirectional sensor )         %
%                                              %
%  Created : 18/05/2005                        %
%   Author : Christopher Mei                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% K contains the calibration values
% K=[k1;k2;k3;k4;k5;alpha;gamma1;gamma2;c1;c2]
%
function P = fullLifting(X, K)

if nargin==0
  disp('Launching test...');
  test;
  return
end

KK=makeKK(K(7:11));
    
P = inv(KK)*[X;ones(1,size(X,2))];
P = undistort(K(2:6),P);
P = pointLifting(P,K(1));

function test
%%% Values %%%
X=100*randn(2,1);
K=randn(5,1)*1e-5;
%K(3:5)=zeros(3,1);
%K=zeros(5,1);

alpha=abs(randn(1,1)*1e-3);
F=abs(randn(2,1)*10);
C=abs(randn(2,1)*100);

epsilon = 1;

p=1;
d=0;
type=1;
[xi,phi]=pd2xiphi(p,d,type);
eta = xi-phi;

xi = 0.8;

K=[xi;K;alpha;F*eta;C];

P=fullLifting(X,K);
X2=omniCamProjection(P, [1;zeros(6,1);K]);

error=norm(X-X2);

if error ~= 0
  disp(['Error lifting and then reprojecting : 1e' slog10(error)]);
else
  disp(['Error lifting and then reprojecting : 0']);
end

function s=slog10(val)
s=num2str(floor(log10(val)));
