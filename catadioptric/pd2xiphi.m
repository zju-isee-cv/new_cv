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
% Calculates the parameters used in unified    %
%           projection model                   %
%                                              %
%  Created : 04/03/2005                        %
%   Author : Christopher Mei                   %
% Based on : Barreto PhD 2003                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%% Exemple %%%%%%%%%%%%%%%%%%%%
% Paraboloid
% pd2xiphi(0.12,0,1)

%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%%%
% p : latus rectum
% d : distance between focal points (any for paraboloid)
% type : Perspective (0)/Paraboloid (1)/Hyperboloid (2)/Ellipsoid (3)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xi,phi]=pd2xiphi(p,d,type)

%Conic parameters
switch type
 case 0
  xi = 0;
  phi = 1;
 case 1
  xi=1;
  phi=1+2*p;
 case 2
  xi=d/sqrt(d^2+4*p^2);
  phi=(d+2*p)/sqrt(d^2+4*p^2);
 case 3
  xi=d/sqrt(d^2+4*p^2);
  phi=(d-2*p)/sqrt(d^2+4*p^2);
end
