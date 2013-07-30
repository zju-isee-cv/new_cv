check_active_images;

for kk =  ind_active
  if isempty(x_{kk})
    fprintf(1,'WARNING: Need to extract grid corners on image %d\n',kk);
      
    active_images(kk) = 0;
    
    dX_{kk} = NaN;
    dY_{kk} = NaN; 
    wintx_{kk} = NaN;
    winty_{kk} = NaN;
    x_{kk} = NaN*ones(2,1);
    X_{kk} = NaN*ones(3,1);  
    n_sq_x_{kk} = NaN;
    n_sq_y_{kk} = NaN;
    
  else
    xkk = x_{kk};
    
    if isnan(xkk(1))
      fprintf(1,'WARNING: Need to extract grid corners on image %d - This image is now set inactive\n',kk);
      active_images(kk) = 0;
    end      
   end   
end
