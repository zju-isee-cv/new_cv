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
% This function uses the Levenberg-Marquardt      %
% algorithm to calculate X, P=distortion(X,K)     %
% knowing P and K.                                %
%                                                 %
%   Created : 2005                                %
%    Author : Christopher Mei                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [X,error,k] = undistort(K, P)

if nargin==0
  disp('Launching test...');
  test;
  return
end

if (isequal(K,zeros(5,1)))
  X=P;
  error=0;
  k=0;
  return
end

if(K(5)~=0)
  n=3;
  k=K(5);
  allNull=0;
elseif(K(2)~=0)
  n=2;
  k=K(2);
  allNull=0;
else
  allNull=1;
end

if size(P,1)==3
  P=P(1:2,:);
end
n=size(P,2);
X=zeros(2,n);

fullError=[];
iterations=[];

VERS = version;
VERS = VERS(1);

for i=1:n
  if allNull
    X0=[0;0];
  else
    px=P(1,i);
    py=P(2,i);
    
    pr=(px^2+py^2)/k^2;
    x0=px/k*pr^(-n/(2*n+1));
    y0=py/k*pr^(-n/(2*n+1));
    
    X0=[x0;y0];
  end
  if(VERS=='7')
    [X(:,i),error,k]=levenbergMarquardt(@distortion2,K,X0,P(:,i));
  else
    [X(:,i),error,k]=levenbergMarquardt6(@distortionf,@distortionj,K,X0,P(:,i));
  end
  fullError=[ fullError;error];
  iterations=[iterations;k];
end

error=fullError;
k=iterations;

function test
%%% Values %%%
X=10*randn(2,1);
K=randn(5,1)*1e-3;
%K=zeros(5,1);
%K(5)=0;
%K(2)=0;

P=distortion(X,K);

[Y,error,k]=undistort(K,P)

if error ~= 0
  disp(['Error : 1e' slog10(error)]);
else
  disp(['Error : 0']);
end

function s=slog10(val)
s=num2str(floor(log10(val)));

function [P,dPdX]=distortion2(K,X)
[P,dPdK,dPdX]=distortion(X,K);
