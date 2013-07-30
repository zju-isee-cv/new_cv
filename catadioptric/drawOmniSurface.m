function drawOmniSurface(images,gridInfo,paramEst)

close all

XI = [paramEst.sxi;paramEst.kc;paramEst.alpha_c;...
      paramEst.gammac(1);paramEst.gammac(2);...
      paramEst.cc(1);paramEst.cc(2)];


V = [1;0;0;0;0;0;0;XI];

resol = 1/500;

[imx,imy] = meshgrid(-1:resol:1,-1:resol:1);

spx = size(imx,1);
spy = size(imx,2);
size_im = spx*spy;

pts_lower = [reshape(imx,1,size_im);
	     reshape(imy,1,size_im); ...
	     reshape(-sqrt(1-imx.^2-imy.^2),1,size_im)];

resol2 = 1/10;
[x_lower,y_lower] = meshgrid(-1:resol2:1,-1:resol2:1);
z_lower = -sqrt(1-x_lower.^2-y_lower.^2);
z_lower(find(real(z_lower(:))~=z_lower(:))) = NaN;

%z_lower

%find(isreal(pts_lower(3,:)))
%isreal(pts_lower(3,:))
%pts_lower(3,200:205)
%pts_lower(3,:)

%pts_lower =
%pts_lower(:,find(real(pts_lower(3,:))==pts_lower(3,:)));
pts_lower(3,:) = real(pts_lower(3,:));

pts_upper = pts_lower;
pts_upper(3,:) = -pts_upper(3,:);

%plot3(pts_lower(1,:),pts_lower(2,:),pts_lower(3,:),'bx');
%plot3(pts_upper(1,:),pts_upper(2,:),pts_upper(3,:),'rx');

im_pts_lower = omniCamProjection(pts_lower, V, paramEst.bounded_xi);

size(im_pts_lower)
size(imx,1)
spx
u_lower = reshape((im_pts_lower(1,:)),size(imx,1),size(imx,2));
v_lower = reshape((im_pts_lower(2,:)),size(imy,1),size(imy,2));

im_pts_upper = omniCamProjection(pts_upper, V, paramEst.bounded_xi);
u_upper = reshape(round(im_pts_upper(1,:)),size(imx,1),size(imx,2));
v_upper = reshape(round(im_pts_upper(2,:)),size(imy,1),size(imy,2));

I = images.I{1};
size(I)
warped_lower = interp2(I(:,:),u_lower,v_lower,'linear');
%warped_upper = interp2(I(:,:),u_upper,v_upper,'linear');

%figure(201);
%imshow(uint8(warped_lower))

if 1
  %figure(302);
  hold on;
  draw3DFrame(2);
  %h = surface(x,y,z);
  h = surface(x_lower,y_lower,z_lower);
  %set(h)
  set(h,'CData',warped_lower,'FaceColor','texturemap'), colormap(gray)
  %alpha_mask = ones(size(warped_lower));
  %alpha_mask = zeros(size(warped_lower));
  %set(h,'edgecolor','none','facealpha','texture','alphadata',alpha_mask);
  axis equal
end
%figure(201);
%imshow(uint8(warped_lower))
%figure(201)

%I_low;
