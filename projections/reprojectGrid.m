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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                            %
%               Project the image of the grids               %
%                                                            %
%           Author : Christopher Mei                         %
%             Date : 18/04/06                                %
%                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Input :
%
% Output :
%
function reprojectGrid(initial_mirror_values,images,gen_KK_est,gridInfo,paramEst)

grid_show = input('Grids(s) to reproject ([] = all active images) : ');

if isempty(grid_show)
  grid_show = ind_active;
end

C=couleur();
nbColors=size(C,1);

if ~isfield(paramEst,'gammac')
  XI=[initial_mirror_values.mirror_sxi;zeros(5,1);0;...
      gen_KK_est(1,1);gen_KK_est(2,2); ...
      gen_KK_est(1,3);gen_KK_est(2,3)];
else
  XI=[paramEst.sxi;paramEst.kc;paramEst.alpha_c;...
      paramEst.gammac(1);paramEst.gammac(2);...
      paramEst.cc(1);paramEst.cc(2)];
end


for i=1:length(grid_show)
  index = grid_show(i);

  I = images.I{index};

  % To get an idea of the number of pixels needed
  nb_pix = ceil(max(max(gridInfo.x{index}(1,:))-min(gridInfo.x{index}(1,:)),...
		    max(gridInfo.x{index}(2,:))-min(gridInfo.x{index}(2,:))))
  
  n_sq_x = gridInfo.n_sq_x{index};
  n_sq_y = gridInfo.n_sq_y{index};
  
  rate = min(n_sq_x/nb_pix, n_sq_y/nb_pix);
    
  % Add an extra bit (-1,+1) to grid to enable extraction
  [imx,imy] = meshgrid(gridInfo.dX{index}*(-1:rate:n_sq_y+1),...
  		       gridInfo.dY{index}*(-1:rate:n_sq_x+1));
  spx = size(imx,1);
  spy = size(imx,2);
  size_im = spx*spy;

  pts = [reshape(imx,1,size_im);reshape(imy,1,size_im); ...
	 zeros(1, size_im)];
  
  V = [paramEst.Qw{index};paramEst.Tw{index};XI];
  im_pts = omniCamProjection(pts, V, paramEst.bounded_xi);
  
  x = reshape(im_pts(1,:),size(imx,1),size(imx,2));
  y = reshape(im_pts(2,:),size(imy,1),size(imy,2));
  
  warped = interp2(I(:,:),x,y,'linear');
  
  figure(200+index);
  imshow(uint8(warped))
  hold on
  
  % Lift extracted points
  x_lift = fullLifting(gridInfo.x{index},XI,paramEst.bounded_xi);
  R = quat2mat(paramEst.Qw{index}/norm(paramEst.Qw{index}));
  x_lift = R(:,3)'*paramEst.Tw{index}*x_lift./(ones(3,1)*R(:,3)'*x_lift);
  x_plane = inv_rigid_motion_quat(x_lift,paramEst.Qw{index},paramEst.Tw{index});
  
  x_image = 1/rate*[x_plane(1,:)/gridInfo.dX{index}+1;
		    x_plane(2,:)/gridInfo.dY{index}+1];
  X_image = 1/rate*[gridInfo.X{index}(1,:)/gridInfo.dX{index}+1;
		    gridInfo.X{index}(2,:)/gridInfo.dY{index}+1];
  
  plot(x_image(1,:),x_image(2,:),'r+');
  plot(X_image(1,:),X_image(2,:),'yx');
  
  real_x_image = cornerfinder(X_image,warped,20,20);
  plot(real_x_image(1,:),real_x_image(2,:),'g+');
  
  real_x_{index}=[(real_x_image(1,:)*rate-1)*gridInfo.dX{index};...
		  (real_x_image(2,:)*rate-1)*gridInfo.dY{index};...
		  zeros(1,size(real_x_image,2))];
  
  real_x_{index} = omniCamProjection(real_x_{index}, V, paramEst.bounded_xi);
  
  figure(300+index);
  plot(x_image(1,:)-real_x_image(1,:),x_image(2,:)-real_x_image(2,:),'r+');
  ax = axis;
  axis_max = max(abs(ax));
  
  axis([-axis_max axis_max -axis_max axis_max]);
  axis square
  
  title('Reprojection of grid in its own frame');
end

axis square;
