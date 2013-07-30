%
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
%       Estimate 'gamma' from aligned points      %
%                                                 %
%  Created : 16/03/2006 (mod 06/08/06)            %
%   Author : Christopher Mei                      %
%                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input :
%   L : 2xN aligned points (with N>=4)
%   cc : principal point
%
% Output :
%   N : line normal
%   gamma : estimate of the extended focal
%   corr : flag indicating if the extraction has succeeded
%
function [N,gamma,corr] = estimate_gamma(L,cc)

if size(L,2)<4
  disp('At least four points are needed.');
  N = 0;
  gamma = 0;
  corr = 0;
  return
end

L = L-repmat(cc,1,size(L,2));
P = [L;1/2*ones(1,size(L,2));-1/2*sum(L.^2,1)];

[U,S,V] = svd(P');
V = V(:,4);
val = norm(P'*V);

val = V(1)^2+V(2)^2+V(3)*V(4);

if val<0
  corr = 0;
  N = 0;
  gamma = 0;
  return
else
  corr = 1;
end

d = sqrt(1/val);

nx = V(1)*d;
ny = V(2)*d;

if nx^2+ny^2>0.95
  disp('Please do not choose a radial line.');
  N = 0;
  gamma = 0;
  corr = 0;
  return
end

nz = sqrt(1-nx^2-ny^2);
N = [nx;ny;nz];
gamma = V(3)*d/nz;

