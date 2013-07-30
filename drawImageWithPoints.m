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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                            %
%      Draws extracted and reprojected       %
%      points on the calibration images      %
%                                            %
%   Created : 2005 (mod 11/03/06)            %
%    Author : Christopher Mei                %
%                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input : 
%   see "click_calib.m"
%
% Output :
%


function drawImageWithPoints(images,gen_KK_est,gridInfo,paramEst)

if ~isfield(images,'I')
  disp('Cannot draw corners without images');
  return
end

active_images = images.active_images;
ind_active = find(active_images);

ima_show = input('Image(s) to show ([] = all active images) : ');

if isempty(ima_show)
  ima_show = ind_active;
end

if ~isfield(paramEst,'gammac')
  XI=[paramEst.xi;zeros(5,1);0;...
      gen_KK_est(1,1);gen_KK_est(2,2); ...
      gen_KK_est(1,3);gen_KK_est(2,3)];
else
  XI=[paramEst.xi;paramEst.kc;paramEst.alpha_c;...
      paramEst.gammac(1);paramEst.gammac(2);...
      paramEst.cc(1);paramEst.cc(2)];
end

for i=1:length(ima_show)
  index = ima_show(i);
    
  if size(gridInfo.x,2)<index
    break;
  end
  if isempty(gridInfo.x{index})
    continue
  end
  
  figure(i+1);
  if exist('imshow')&exist('uint8')
    imshow(uint8(images.I{index}));
  else
    image(I);
    colormap(gray(256));
  end
  hold on;
  
  plot(gridInfo.x{index}(1,:),gridInfo.x{index}(2,:),'r+');

  if(isfield(gridInfo,'real_x'))
    plot(gridInfo.real_x{index}(1,:),gridInfo.real_x{index}(2,:),'g+');
  end
  
  V = [paramEst.Qw{index};paramEst.Tw{index};XI];

  [XX,dXXdV] = omniCamProjection(gridInfo.X{index}, V);

  plot(XX(1,:),XX(2,:),'yx');
end

[err_mean_abs,err_std_abs,err_std] = comp_omni_error(images,gen_KK_est,paramEst,gridInfo);
err_std_abs
