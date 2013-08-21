function drawImageWithPoints(images,gen_KK_est,gridInfo,paramEst3D)
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


if ~isfield(paramEst3D,'gammac')
  XI=[paramEst3D.Q;paramEst3D.xi1;paramEst3D.xi2;paramEst3D.xi3;... %%%%%%%%dx
      zeros(5,1);0;...
      gen_KK_est(1,1);gen_KK_est(2,2); ...
      gen_KK_est(1,3);gen_KK_est(2,3)];
else
  XI=[paramEst3D.Q;paramEst3D.xi1;paramEst3D.xi2;paramEst3D.xi3;...%%%%%%%%%%%dx
      paramEst3D.kc;paramEst3D.alpha_c;...
      paramEst3D.gammac;paramEst3D.cc];
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
  
  V = [paramEst3D.Qw{index};paramEst3D.Tw{index};XI];

  XX = omniCamProjection3D(gridInfo.X{index}, V);

  plot(XX(1,:),XX(2,:),'yx');
end

[err_mean_abs3D,err_std_abs3D,err_std3D] = comp_omni_error3D(images,gen_KK_est,paramEst3D,gridInfo);
err_std_abs3D