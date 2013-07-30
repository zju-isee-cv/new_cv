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
%     Calculates arccos and its jacobian          %
%                                                 %
%   Created : 2005                                %
%    Author : Christopher Mei                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [P,dPdX]=arccos(X)

if nargin==0
  disp('Launching test...');
  test;
  return
end
switch nargout
 case 0
 case 1
  P=acos(X);
 case 2
  P=acos(X);
  dPdX = jacobianX(X);
 otherwise
  disp('Too many output args.')
end

function test
error=1e-4;
disp(['Error : 1e' slog10(error)]);

%%% Values %%%
X=randn(1,1);
dX=randn(1,1)*error;

[P,dPdX]=arccos(X);

%%% Test derivation in X %%%
Pp=arccos(X+dX);

gainP=norm(Pp-P)/norm(Pp-P-dPdX*dX);
disp(['Estimate gain in X : 1e' slog10(gainP)]);


function P=jacobianX(X)
P=-1./sqrt(1-X'.^2);

function s=slog10(val)
s=num2str(floor(log10(val)));
