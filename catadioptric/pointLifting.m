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
%    Lifts points on normalised plane          %
%                                              %
%  Created : 08/11/2005                        %
%   Author : Christopher Mei                   %
% Based on : Barreto PhD 2003                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%%%
% M : 2xN points to lift (on the normalised plane)
% xi : mirror parameter
%
%%%%%%%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%%%
% Xs : 3xM point on the sphere
% dXsdM : jacobian of Xs with respect to entry M
%
function [Xs,dXsdM] = pointLifting(M, xi)

if nargin==0
  disp('Launching test...');
  test;
  return
end

switch nargout
 case 0
 case 1
  Xs=lift(M, xi);
 case 2
  Xs=lift(M, xi);
  dXsdM = jacobianMFull(M, xi);
 otherwise
  disp('Too many output args.')
end

function test
error = 1e-4;
disp(['Error : 1e' slog10(error)]);

%%% Values %%%
M = 10*randn(2,1);
dM = 10*randn(2,1)*error;

p = 16.7;
d = 10; 
type = 1;

epsilon = -1;

xi = pd2xiphi(p,d,type);

[Xs,dXsdM] = pointLifting(M,xi);

%%% Test derivation in M %%%
Xsp = pointLifting(M+dM,xi);
dXs = dXsdM*dM;

N = norm(Xsp-Xs-dXs);

if N~=0
  gainXs = norm(Xsp-Xs)/N;
  disp(['Estimate gain in Xs : 1e' slog10(gainXs)]);
else
  disp(['Estimate gain in Xs : Inf']);
end

function Xs = lift(M, xi)

x2 = M(1,:).^2;
y2 = M(2,:).^2;

lambda = (xi+sqrt(1+(1-xi^2)*(x2+y2)))./(x2+y2+1);

Xs = [ lambda.*M(1,:);
       lambda.*M(2,:);
       lambda-xi ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dXsdM = jacobianMFull(M,xi)
[m,n] = size(M);
dXsdM=zeros(3*n,m);

for i=1:n
  dXsdM(3*(i-1)+1:3*i,1:m)=jacobianM(M(:,i),xi);
end

function dXsdM = jacobianM(M,xi)
x=M(1); y=M(2);

n2=x^2+y^2+1;
s=sqrt(xi^2+(1-xi^2)*n2);
t=xi+s;

lambda=t/n2;
dlamdbadM=-1/(s*n2^2)*[t^2*x t^2*y];

dXsdM=[M;1]*dlamdbadM+lambda*eye(3,2);

function s=slog10(val)
s=num2str(floor(log10(val)));
