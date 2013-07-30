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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                   %
%            Draws a 3D view of the grids           %
%                                                   %
%    Created : 13/03/06                             %
%     Author : Christopher Mei                      %
%                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function drawGrids3D(images,gen_KK_est,gridInfo,paramEst)

ind_active = find(images.active_images);

grid_show = input('Grids(s) to show ([] = all active images) : ');

if isempty(grid_show)
  grid_show = ind_active;
end

C=couleur();
nbColors=size(C,1);

if ~isfield(paramEst,'gammac')
  XI=[paramEst.xi;zeros(5,1);0;...
      gen_KK_est(1,1);gen_KK_est(2,2); ...
      gen_KK_est(1,3);gen_KK_est(2,3)];
else
  XI=[paramEst.xi;paramEst.kc;paramEst.alpha_c;...
      paramEst.gammac(1);paramEst.gammac(2);...
      paramEst.cc(1);paramEst.cc(2)];
end

figure(100);
hold on;
draw3DFrame(0.1);

for index=grid_show
  if ~ind_active(index)
    continue;
  end

  
  % Translate and rotate points according to parameters
  pts = 1e-3*rigid_motion_quat(gridInfo.X{index},paramEst.Qw{index}/norm(paramEst.Qw{index}),paramEst.Tw{index});
  
  plot3(pts(1,:),pts(2,:),pts(3,:),'x','color',C(mod(3*(index+10), ...
						  nbColors)+1,:));
  text(pts(1,1),pts(2,1),pts(3,1),['Grid ' num2str(index)]);
end

title('Grids in the camera frame (in m)');
axis square;
axis equal;
