%
% Draws the images
%
% Input :
%  images : see "data_calib.m"
%
function mosaic(images)

if isempty(find(images.active_images))
  disp('No active images');
  return
end

n_ima = images.n_ima;

[ny,nx] = size(images.I{1});

n_col = floor(sqrt(n_ima*nx/ny));
n_row = ceil(n_ima / n_col);


ker2 = 1;
for ii  = 1:n_col,
  ker2 = conv(ker2,[1/4 1/2 1/4]);
end

I_1 = images.I{1};
II = I_1(1:n_col:end,1:n_col:end);

[ny2,nx2] = size(II);


kk_c = 1;

II_mosaic = [];

for jj = 1:n_row,
  
  II_row = [];
  
  for ii = 1:n_col,
    
    if (kk_c <= n_ima) & ~isempty(images.I{kk_c})
      
      if images.active_images(kk_c),
	I = images.I{kk_c};
	%I = conv2(conv2(I,ker2,'same'),ker2','same'); % anti-aliasing
	I = I(1:n_col:end,1:n_col:end);
      else
	I = zeros(ny2,nx2);
      end;
      
    else
      
      I = zeros(ny2,nx2);
      
    end;
      
    II_row = [II_row I];
    
    if ii ~= n_col,
      
      II_row = [II_row zeros(ny2,3)];
      
    end;
    
    
    kk_c = kk_c + 1;
    
  end;
  
  nn2 = size(II_row,2);
  
  if jj ~= n_row,
    II_row = [II_row; zeros(3,nn2)];
  end;
  
  II_mosaic = [II_mosaic ; II_row];
  
end;

figure(2);
image(II_mosaic);
colormap(gray(256));
title('Calibration images');
set(gca,'Xtick',[])
set(gca,'Ytick',[])
axis('image');
