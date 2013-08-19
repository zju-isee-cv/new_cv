%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           %
%      Grid extraction process manually     %
%                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gridInfo,paramEst3D] = new_grid_extraction(images,gen_KK_est,gridInfo,paramEst3D)

if isempty(gridInfo)
  % Default square size 30x30 (mm)
  gridInfo.dX_default = 30;
  gridInfo.dY_default = 30;
  % Default grid size : 10x10
  gridInfo.n_sq_x_default = 10;
  gridInfo.n_sq_y_default= 10;
  % Default window used for the subpixel extraction
  wintx_default = max(round(images.nx/(2*128)),round(images.ny/(2*96)));
  gridInfo.wintx_default = wintx_default;
  gridInfo.winty_default = wintx_default;
end

n_ima = images.n_ima;

%check_active_images;

ind_read = find(images.active_images);

if isempty(ind_read),
  disp('Cannot extract corners without images');
  return
end

fprintf(1,['\nExtraction of the grid corners on the images ' ...
	   '(at each correct grid extraction, the values are '...
	   ' save in "calib_data.mat")\n']);
   
ima_numbers = input('Number(s) of image(s) to process ([] = all images) = ');

if isempty(ima_numbers),
  ima_proc = 1:n_ima;
else
  ima_proc = ima_numbers;
end


% Useful option to add images:
kk_first = ima_proc(1);

%if isempty(kk_first), kk_first = 1; end

if isfield(gridInfo,'wintx') & size(gridInfo.wintx,2) >= kk_first
  wintxkk = gridInfo.wintx{kk_first};
    
  if isempty(wintxkk) | isnan(wintxkk)
  
    disp('Window size for corner finder (wintx and winty):');
    wintx = input(['wintx ([] = ' num2str(gridInfo.wintx_default) ') = ']);
    if isempty(wintx), wintx = gridInfo.wintx_default; end
    wintx = round(wintx);
    winty = input(['winty ([] = ' num2str(gridInfo.winty_default) ') = ']);
    if isempty(winty), winty = gridInfo.winty_default; end
    winty = round(winty);
  
    fprintf(1,'Window size = %dx%d\n',2*wintx+1,2*winty+1);
  
  else
    wintx = gridInfo.wintx{kk_first};
    winty = gridInfo.winty{kk_first};
  end

else

  disp('Window size for corner finder (wintx and winty):');
  wintx = input(['wintx ([] = ' num2str(gridInfo.wintx_default) ') = ']);
  if isempty(wintx), wintx = gridInfo.wintx_default; end
  wintx = round(wintx);
  winty = input(['winty ([] = ' num2str(gridInfo.winty_default) ') = ']);
  if isempty(winty), winty = gridInfo.winty_default; end
  winty = round(winty);

end

gridInfo.wintx_default = wintx;
gridInfo.winty_default = winty;

manual_squares = 1;

for kk = ima_proc
  if ~isempty(images.I{kk})
    [gridInfo,errorExtr,paramEst3D] = new_manual_click_calib(images.I{kk},kk,...
						    gen_KK_est,gridInfo,paramEst3D);
    while errorExtr
    [gridInfo,errorExtr,paramEst3D] = new_manual_click_calib(images.I{kk},kk,...
						    gen_KK_est,gridInfo,paramEst3D);    
    end
    save calib_data gridInfo paramEst3D;
    images.active_images(kk) = 1;
  end
end   
disp('done');
end