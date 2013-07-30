%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   %
%      Grid extraction process      %
%                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input : see "mirror_values.m", "data_calib.m" and
%         "border_estimate.m"
%
% Output :
%   gridInfo : structure containing :
%     dX : size of the grid in X in mm.
%     dY : size of the grid in Y in mm.
%     n_sq_x : number of squares in X
%     n_sq_y : number of squares in Y
%     X : list of 3D grid points
%     x : list of extracted grid corners in the images
%
%   paramEst : structure containing :
%     Qw : list of quaternion values (extrinsic parameters)
%     Tw : list of translation values (extrinsic parameters)
%
function [gridInfo, paramEst] = click_calib(images,gen_KK_est,gridInfo,paramEst)

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
    [gridInfo,paramEst,errorExtr] = click_ima_calib(images.I{kk},kk,...
						    gen_KK_est,gridInfo,paramEst);
    while errorExtr
      [gridInfo,paramEst,errorExtr] = click_ima_calib(images.I{kk},kk,...
						      gen_KK_est,gridInfo,paramEst);
    end
    save calib_data gridInfo paramEst;
    images.active_images(kk) = 1;
  end
end

%check_active_images;

images_without_I.n_ima = images.n_ima;
images_without_I.image_numbers = images.image_numbers;
images_without_I.active_images = images.active_images;
images_without_I.ind_active = images.ind_active;
images_without_I.N_slots = images.N_slots;
images_without_I.type_numbering = images.type_numbering;
images_without_I.calib_name = images.calib_name;
images_without_I.format_image = images.format_image;

save calib_data images_without_I gen_KK_est gridInfo paramEst;

disp('done');

[err_mean_abs,err_std_abs,err_std] = comp_omni_error(images,gen_KK_est,paramEst,gridInfo);
fprintf(1,'Pixel error:          err = [ %3.5f   %3.5f ]\n',err_std);



