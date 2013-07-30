check_border_estimate;

if missing
  return
end

if ~exist('borderInfo','var')|~exist('gen_KK_est','var')
  disp('Please use ''Estimate camera intri.'' first.');
  missing = 1;
  return
end

if ~exist('gridInfo','var')
  gridInfo = [];
end

missing = 0;
