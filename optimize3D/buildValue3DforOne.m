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
function sfxp1 = buildValue3DforOne(n_ima, gridInfo, QTparam, systemparam, ima_number) %get the value of F(x), the error of the reprojection.

  x = omniCamProjection3D(gridInfo.X{ima_number},...
        [QTparam; systemparam]);
%       [param(13+7*(kk-1)+1 : 13+7*(kk-1)+7);param(1:13)]);
% 			[param(11+7*(kk-1)+1 : 11+7*(kk-1)+7);param(1:11)]);
  exkk = x-gridInfo.x{ima_number};
  [nlines,ncols]=size(exkk);
  sfxp1= reshape(exkk,ncols*nlines,1);
