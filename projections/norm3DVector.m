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
%         Calculates the norm function            %
%               and its jacobian                  %
%                                                 %
%   Created : 2005                                %
%    Author : Christopher Mei                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [nV,dnVdV] = norm3DVector(V)
if nargin==0
  disp('Launching test...');
  test;
  return
end
  
switch nargout
 case 0
 case 1
  nV=normalise(V);
 case 2
  nV=normalise(V);
  dnVdV=jacobianVFull(V);
 otherwise
  disp('Too many output args.')
end

function nV=normalise(V)
nV=zeros(size(V));

for i=1:size(V,2)
  nV(:,i)=V(:,i)/norm(V(:,i));
end

function dnVdV = jacobianVFull(V)
n = size(V,2);
dnVdV=zeros(3*n,3);

for i=1:n
  dnVdV(3*(i-1)+1:3*i,:)=jacobianV(V(:,i));
end

function dnVdV=jacobianV(V)
v0=V(1); v1=V(2); v2=V(3);

dnVdV = [[v1^2+v2^2;...
	  -v0*v1;...
	  -v0*v2],...
	 ...
	 [-v0*v1;...
	  v0^2+v2^2;...
	  -v1*v2],...
	 ...
	 [-v0*v2;...
	  -v1*v2;...
	  v0^2+v1^2]]/norm(V)^3;

function test
error=1e-4;
disp(['Error : 1e' slog10(error)]);

%%% Values %%%
V=10*randn(3,1);
dV=10*randn(3,1)*error;

[nV,dnVdV]=norm3DVector(V);

%%% Test derivation in V %%%
nVp=norm3DVector(V+dV);
dnV=dnVdV*dV;

gainV=norm(nVp-nV)/norm(nVp-nV-dnV);
disp(['Estimate gain in V : 1e' slog10(gainV)]);

function s=slog10(val)
s=num2str(floor(log10(val)));
