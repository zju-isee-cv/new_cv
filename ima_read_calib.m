%
% Loads the images that are active
%
% Input :
% 
%
% Load images
%
% Input :
%   images : see "data_calib.m"
%
% Output :
%   I : array of images
%   active_images : images that were read
%   ind_read : index of read images
%
function [I,active_images,ind_read] = ima_read_calib(images)

images_read = images.active_images;
active_images = images.active_images;
ind_active = images.ind_active;
first_num = images.image_numbers(1);
n_ima = images.n_ima;

image_numbers = first_num:n_ima-1+first_num;

no_image_file = 0;

i = 1;

while (i <= n_ima), % & (~no_image_file),
  
  if active_images(i),
    
    if ~images.type_numbering,   
      number_ext =  num2str(image_numbers(i));
    else
      number_ext = sprintf(['%.' num2str(images.N_slots) 'd'],image_numbers(i));
    end;
    
    ima_name = [images.calib_name  number_ext '.' images.format_image];
    
    if i == ind_active(1),
      fprintf(1,'Loading image ');
    end;
    
    if exist(ima_name),
      
      fprintf(1,'%d...',i);
      
      if images.format_image(1) == 'p',
	if images.format_image(2) == 'p',
	  Ii = double(loadppm(ima_name));
	else
	  Ii = double(loadpgm(ima_name));
	end;
      else
	if images.format_image(1) == 'r',
	  Ii = readras(ima_name);
	else
	  Ii = double(imread(ima_name));
	end;
      end;

      
      if size(Ii,3)>1,
	Ii = 0.299 * Ii(:,:,1) + 0.5870 * Ii(:,:,2) + 0.114 * Ii(:,:,3);
      end;
      
      I{i} = Ii;
      
    else
      
      images_read(i) = 0;
      
    end;
    
  end;
  
  i = i+1;   
  
end;


ind_read = find(images_read);

if isempty(ind_read),
  
  fprintf(1,'\nWARNING! No images were read\n');
  
end

active_images = images_read;
