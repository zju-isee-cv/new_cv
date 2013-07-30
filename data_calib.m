%%% This script asks the user to enter the name of the images (base name, numbering scheme,...)

%
% images : structure with
%   n_ima : number of images
%   image_numbers : 1x(n_ima) matrix of image 'indexes' or 'numbers'
%                   (eg. image_0008.pgm -> 8)
%   active_images : 1x(n_ima) matrix of boolean that indicates the
%                   chosen images (default : all images are active)
%   ind_active : 1x(n_ima) matrix of indexes for chosen images
%   N_slots : number of numbers for the image numbering (eg. image_0008.pgm -> 4)
%   type_numbering : boolean (1 : image_0018.pgm) (0: image_18.pgm)
%   calib_name : base name of the images (eg. 'image_0008.pgm' -> 'image_')
%   format_image  : image format (ras, bmp, tif, ...) (eg. 'image_0008.pgm' -> 'pgm' )
%   I : array of images
%
function images = data_calib()

% Checks that there are some images in the directory :

l_ras = dir('*ras');
s_ras = size(l_ras,1);
l_bmp = dir('*bmp');
s_bmp = size(l_bmp,1);
l_tif = dir('*tif');
s_tif = size(l_tif,1);
l_pgm = dir('*pgm');
s_pgm = size(l_pgm,1);
l_ppm = dir('*ppm');
s_ppm = size(l_ppm,1);
l_jpg = dir('*jpg');
s_jpg = size(l_jpg,1);

s_tot = s_ras + s_bmp + s_tif + s_pgm + s_jpg + s_ppm;

if s_tot < 1
  fprintf(1,'No image in this directory in either ras, bmp, tif, pgm, ppm or jpg format. Change directory and try again.\n');
  images = [];
  return
end


% IF yes, display the directory content:

dir;

Nima_valid = 0;

while (Nima_valid==0)
  
  fprintf(1,'\n');
  calib_name = input('Basename camera calibration images (without number nor suffix): ','s');
  
  format_image = '0';
  
  while format_image == '0',
    
    format_image =  input('Image format: ([]=''r''=''ras'', ''b''=''bmp'', ''t''=''tif'', ''p''=''pgm'', ''j''=''jpg'', ''m''=''ppm'') ','s');
    
    if isempty(format_image),
      format_image = 'ras';
    end;
    
    if lower(format_image(1)) == 'm',
      format_image = 'ppm';
    else
      if lower(format_image(1)) == 'b',
	format_image = 'bmp';
      else
	if lower(format_image(1)) == 't',
	  format_image = 'tif';
	else
	  if lower(format_image(1)) == 'p',
	    format_image = 'pgm';
	  else
	    if lower(format_image(1)) == 'j',
	      format_image = 'jpg';
	    else
	      if lower(format_image(1)) == 'r',
		format_image = 'ras';
	      else  
		disp('Invalid image format');
		format_image = '0'; % Ask for format once again
	      end;
	    end;
	  end;
	end;
      end;
    end;
  end;
  
  [n_ima,image_numbers,active_images,N_slots,type_numbering,Nima_valid] = check_directory(calib_name,format_image);
  
end

images.n_ima = n_ima;
images.image_numbers = image_numbers;
images.active_images = active_images;
images.ind_active = find(active_images);
images.N_slots = N_slots;
images.type_numbering = type_numbering;

images.calib_name = calib_name;
images.format_image = format_image;


if (Nima_valid~=0),
  % Reading images:
  
  [I,active_images,ind_read] = ima_read_calib(images); % may be launched from the toolbox itself

  images.I = I;
  images.active_images = active_images;
  
  % Show all the calibration images
  if ~isempty(ind_read)
    mosaic(images);
  end
end

images.nx = size(images.I{1},2);
images.ny = size(images.I{1},1);
