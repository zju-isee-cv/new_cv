% Re-select the corners after calibration

function [gridInfo,paramEst] = recomp_corner_calib(images,gen_KK_est,gridInfo,paramEst)

n_ima = images.n_ima;
active_images = images.active_images;
ind_active = find(images.active_images);

if n_ima == 0
  fprintf(1,'No image data available\n');
  return
end

fprintf(1,'\nRe-extraction of the grid corners on the images (after first calibration)\n');

disp('Window size for corner finder (wintx and winty):');
wintx = input('wintx ([] = 5) = ');
if isempty(wintx), wintx = 5; end
wintx = round(wintx);
winty = input('winty ([] = 5) = ');
if isempty(winty), winty = 5; end
winty = round(winty);

fprintf(1,'Window size = %dx%d\n',2*wintx+1,2*winty+1);

ima_numbers = input('Number(s) of image(s) to process ([] = all images) = ');

if isempty(ima_numbers),
  ima_proc = 1:n_ima;
else
  ima_proc = ima_numbers;
end


fprintf(1,'Processing image ');

for kk = ima_proc;
  
  if active_images(kk)
    
    fprintf(1,'%d...',kk);
    
    I = images.I{kk};
      
    y = paramEst.y{kk};
    
    %xc = cornerfinder(y+1,I,winty,wintx); % the four
    %corners
    xc = cornerfinder(y,I,winty,wintx); % the four corners
    
    gridInfo.wintx{kk} = wintx;
    gridInfo.winty{kk} = winty;
    
    %eval(['x_' num2str(kk) '= xc - 1;']);
    gridInfo.x{kk} = xc;
     
  end
end

% Recompute the error:
[err_mean_abs,err_std_abs,err_std,paramEst] = comp_omni_error(images,gen_KK_est,paramEst,gridInfo);
err_mean_abs
fprintf(1,' done\n');


