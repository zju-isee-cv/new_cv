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
%   Recomputes the reprojection error         %
%      (based on version by JYB)              %
%                                             %
%   Created : 2005 (mod 11/03/06)             %
%    Author : Christopher Mei                 %
%                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input : 
%   see "click_calib.m"
%
% Output :
%   err_mean_abs : mean absolute error
%   err_std_abs : absolute standard deviation
%   err_std : standard deviation
%

function [err_mean_abs3D,err_std_abs3D,err_std3D,paramEst3D] = comp_omni_error3D(images,gen_KK_est,paramEst3D,gridInfo)

% Reproject the patterns on the images, and compute the pixel errors:
ex = []; % Global error vector

if ~isfield(paramEst3D,'gammac')
  XI=[paramEst3D.Q;paramEst3D.xi1;paramEst3D.xi3;paramEst3D.xi3;... %%%%%%%%dx
      zeros(5,1);0;...
      gen_KK_est(1,1);gen_KK_est(2,2); ...
      gen_KK_est(1,3);gen_KK_est(2,3)];
else
  XI=[paramEst3D.Q;paramEst3D.xi1;paramEst3D.xi2;paramEst3D.xi3;...%%%%%%%%%%%dx
      paramEst3D.kc;paramEst3D.alpha_c;...
      paramEst3D.gammac;paramEst3D.cc];
end

active_images = images.active_images;
ind_active = find(active_images);

for kk = 1:length(ind_active)
  index = ind_active(kk);

  if active_images(kk) & size(paramEst3D.Qw,2)>=kk & ~isempty(gridInfo.X{index})
    V = [paramEst3D.Qw{index};paramEst3D.Tw{index};XI];
        
    xp = omniCamProjection3D(gridInfo.X{index}, V);
    
    part_ex = xp-gridInfo.x{index};
    
    paramEst3D.y{index} = xp;
    paramEst3D.ex{index} = part_ex;
        
    ex=[ex part_ex];
  end
end

err_mean_abs3D = mean(abs(ex),2);
err_std_abs3D = std(abs(ex),0,2);
err_std3D = std(ex')';
