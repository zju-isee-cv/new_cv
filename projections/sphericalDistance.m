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
%     Calculates the distance between two points  %
%              on the unit sphere                 %
%                                                 %
%   Created : 2005                                %
%    Author : Christopher Mei                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function P = sphericalDistance(X, Y)

if nargin==0
  disp('Launching test...');
  test;
  return
end

switch nargout
 case 0
 case 1
  P=transform(X,Y);
 otherwise
  disp('Too many output args.')
end

function test
X=[1;0;0];
Y=[0;1;0];
sphericalDistance(X,Y)*180/pi

function P=transform(X,Y)
P=acos(sum(X.*Y));

