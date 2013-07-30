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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Builds the matrix of the values of the    %
%              projected points               %
%                                             %
%   Created : 2005                            %
%    Author : Christopher Mei                 %
%                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sfxp1 = buildValue3D(n_ima, gridInfo, param, ind_active, paramEst3D) %get the value of F(x), the error of the reprojection.

sfxp1=[];
if(paramEst3D.Q_mask(1) == 0)
    param(1) = 1;
    param(2:4) = [0;0;0];
end
param(5) = param(5) * paramEst3D.xi1_mask;
param(6) = param(6) * paramEst3D.xi2_mask;
if(paramEst3D.xi3_mask == 0)
    param(7) = 1;
end
param(8:12) = param(8:12).* paramEst3D.kc_mask;
param(13) = param(13) * paramEst3D.alpha_c_mask;

for kk = ind_active
  x = omniCamProjection3D(gridInfo.X{kk},...
        [param(17+7*(kk-1)+1 : 17+7*(kk-1)+7);param(1:17)]);
%       [param(13+7*(kk-1)+1 : 13+7*(kk-1)+7);param(1:13)]);
% 			[param(11+7*(kk-1)+1 : 11+7*(kk-1)+7);param(1:11)]);
  exkk = x-gridInfo.x{kk};
  [nlines,ncols]=size(exkk);
  exkk = reshape(exkk,ncols*nlines,1);
  
  sfxp1=[sfxp1;exkk];
end
