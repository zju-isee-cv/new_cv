if ~exist('paramEst','var')
  disp('Please use ''Set mirror values'' first.');
  missing = 1;
  return
end

if ~exist('images','var')
  disp('Please use ''Load images'' first.');
  missing = 1;
  return
end

missing = 0;

