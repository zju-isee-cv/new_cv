check_calib_optim;

if ~exist('undistortPath','var')
  disp('Please set ''undistortPath'' in "SETTINGS.m"');
  missing = 1;
  return
end

missing = 0;
