% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation, version 2.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software Foundation,
% Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                             %
%     Fits a circle to the mirror border to   %
%        initialise intrinsic values          %
%                                             %
%   Created : 2005 (mod 06/08/06)             %
%    Author : Christopher Mei                 %
%                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input : see "mirror_values.m" and "data_calib.m"
%
% Output :
%   gen_KK_est : estimate of the generalised projection matrix
%                from the mirror border
%   borderInfo : structure containing :
%     center_estimate : estimate of the center of the mirror in the image
%     radius_estimate : estimate of the radius of the mirror border
%                       in the image
%
function [gen_KK_est, borderInfo] = border_estimate(images,paramEst)

ind_active = find(images.active_images);

if isempty(ind_active)
  disp('No images are active !!!')
  return
end

if paramEst.dioptric
  fprintf(1,['\nAssuming principal point is in the center of the' ...
	     ' image for initialisation.\n']);

  [nl,nc] = size(images.I{1});
  center_estimate = [nc/2;nl/2];
else
  fprintf(1,['\nExtraction of the mirror border from the images to' ...
	     ' estimate principal point and calculate the region' ...
	     ' of interest (roi).\n']);

  fprintf(1,'Calculating min over all images... ');
  Imin = minImagesDouble(images.I, images.n_ima);
  fprintf(1,'done.\n');

  figure(2);
  imshow(uint8(Imin));
  fprintf(1,['Please click on the mirror center and then on the' ...
	     ' mirror inner border.\n']);
  CR=digipts3(2);
  [center_estimate,radius_estimate]=extractCircle(Imin, CR(:,1),CR(:,2));
  draw2DCircle(center_estimate,radius_estimate,'r-');
  plot(center_estimate(1),center_estimate(2),'yx');
  
  correctExtr = input('Was the extraction successful ? ([]=yes, other=no) : ','s');

  if ~isempty(correctExtr)
    disp(['We will use the values you gave by clicking instead.']);
    center_estimate = CR(:,1);
    radius_estimate = norm(CR(:,1)-CR(:,2));
    draw2DCircle(center_estimate,radius_estimate,'m-');
  end

end

disp('We are now going to estimate the generalised focal (gammac) from line images.');
  
incorrect_answer = 1;
  
while incorrect_answer
  
  use_ima = input('Which image shal we use ? ([] = 1) : ');
  
  if isempty(use_ima)
    I = images.I{ind_active(1)};
    break
  end
  
  if (use_ima <=0)|(use_ima > size(images.I,2))
    disp('Incorrect value');
    continue
  end
  
  if ~images.active_images(use_ima)
    disp('Image not active. Please try another.');
    continue;
  end
  
  I = images.I{use_ima};
  incorrect_answer = 0;
end

correct = 0;

while ~correct
  disp(['Please select at least 4 ALIGNED edge points on a NON-RADIAL' ...
	' line on the grid.']);
  disp('Click with the right button when finished.');
  figure(2)
  imshow(uint8(I));
  P = precisePoints(I);
  [N,gamma,correct] = estimate_gamma(P,center_estimate);
end

gamma = abs(gamma);

gen_KK_est = [gamma 0 center_estimate(1);...
	      0 gamma center_estimate(2);...
	      0 0 1];

borderInfo.center_estimate = center_estimate;

if ~paramEst.dioptric
  borderInfo.radius_estimate = radius_estimate;
end

disp('done.');
