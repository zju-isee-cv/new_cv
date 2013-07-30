check_click_calib;

if missing
  return
end

if ~exist('minInfo','var')
  disp('Expecting ''minInfo'' variable (normally in SETTINGS.m)');
  missing = 1;
  return
end

missing = 0;
