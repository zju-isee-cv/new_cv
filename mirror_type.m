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
%      Asks the user for initial values           % 
%                                                 %
%  Created : 9/03/2006 (mod 06/08/06)             %
%   Author : Christopher Mei                      %
%                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input :
%
% Output :
%   paramEst : structure containing :
%     xi : initial value given to xi
%     dioptric : boolean indicating if we are using a mirror
%
function paramEst = mirror_values()
%%%%%%%%%%%% Obtain mirror_type %%%%%%%%%%%%%
camera_type = 0;

while ((camera_type ~= 1)&(camera_type ~= 2)&(camera_type ~= 3))
  camera_type = input(['Camera type : \n' ...
		    '1 or [] :  parabola (xi=1)\n' ...
		    '2 : catadioptric (hyperbola,ellipse,sphere)\n' ...
		    '3 : dioptric (fisheye) \n' ...
		    'Choice : '],'s');
  
  if isempty(camera_type)
    camera_type = 1;
    est_xi = 1;
    break;
  end
    
  camera_type = str2num(camera_type);
  if isempty(camera_type)|~((camera_type == 1)|(camera_type == 2)|(camera_type == 3))
    disp('Please answer 1 ([]), 2 or 3.');
  else
    if (camera_type==1)
      est_xi = 0;
    else
      est_xi = 1;
    end
  end
end

switch camera_type
 case 1
  disp('Camera type : parabolic.'); 
  dioptric = 0;
 case 2
  disp('Camera type : catadioptric.');
  dioptric = 0;
 case 3
  disp('Camera type : dioptric.');
  dioptric = 1;
end

paramEst.est_xi = est_xi;
paramEst.xi = 1;

paramEst.dioptric = dioptric;
