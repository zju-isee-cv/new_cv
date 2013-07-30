if ~exist('Calib_Results.mat'),
  fprintf(1,'\nCalibration file Calib_Results.mat not found!\n');
  return;
end;

load paramEst3D;
fprintf(1,'\nLoading calibration results from Calib_Results.mat ');

load Calib_Results;

images.n_ima = images_without_I.n_ima;
images.image_numbers = images_without_I.image_numbers;
images.active_images = images_without_I.active_images;
images.ind_active = images_without_I.ind_active;
images.N_slots = images_without_I.N_slots;
images.type_numbering = images_without_I.type_numbering;
images.calib_name = images_without_I.calib_name;
images.format_image = images_without_I.format_image;
images.nx = images_without_I.nx;
images.ny = images_without_I.ny;

I = ima_read_calib(images);

images.I = I;

clear images_without_I I;

fprintf(1,'done\n');
