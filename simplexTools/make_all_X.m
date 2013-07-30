clear all_X;

for kk = ind_active
  eval(['all_X{' num2str(kk) '}= X_' num2str(kk) ';']);
end
