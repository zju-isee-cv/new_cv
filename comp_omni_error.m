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

function [err_mean_abs,err_std_abs,err_std,paramEst] = comp_omni_error(images,gen_KK_est,paramEst,gridInfo)

% Reproject the patterns on the images, and compute the pixel errors:
ex = []; % Global error vector

if ~isfield(paramEst,'gammac')
  XI=[paramEst.xi;zeros(5,1);0;...
      gen_KK_est(1,1);gen_KK_est(2,2); ...
      gen_KK_est(1,3);gen_KK_est(2,3)];
else
  XI=[paramEst.xi;paramEst.kc;paramEst.alpha_c;...
      paramEst.gammac;paramEst.cc];
end

active_images = images.active_images;
ind_active = find(active_images);

for kk = 1:length(ind_active)
  index = ind_active(kk);

  if active_images(kk) & size(paramEst.Qw,2)>=kk & ~isempty(gridInfo.X{index})
    V = [paramEst.Qw{index};paramEst.Tw{index};XI];
        
    xp = omniCamProjection(gridInfo.X{index}, V);
    
    part_ex = xp-gridInfo.x{index};
    
    paramEst.y{index} = xp;
    paramEst.ex{index} = part_ex;
        
    ex=[ex part_ex];
  end
end

err_mean_abs = mean(abs(ex),2);
err_std_abs = std(abs(ex),0,2);
err_std = std(ex')';
