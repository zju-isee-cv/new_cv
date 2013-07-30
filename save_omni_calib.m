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

function save_omni_calib(minInfo,borderInfo,images,gen_KK_est,gridInfo,paramEst, paramEst3D)

save paramEst3D.mat paramEst3D;
save gridInfo.mat gridInfo;
save_name = 'Calib_Results';

cont = findSaveName(save_name);

if cont
  images_without_I.n_ima = images.n_ima;
  images_without_I.image_numbers = images.image_numbers;
  images_without_I.active_images = images.active_images;
  images_without_I.ind_active = images.ind_active;
  images_without_I.N_slots = images.N_slots;
  images_without_I.type_numbering = images.type_numbering;
  images_without_I.calib_name = images.calib_name;
  images_without_I.format_image = images.format_image;
  images_without_I.nx = images.nx;
  images_without_I.ny = images.ny;
  
  fprintf(1,['\nSaving calibration results under ' save_name '.mat ']);
        
  string_save = ['save ' save_name ...
		 ' minInfo borderInfo images_without_I gen_KK_est' ...
		 ' gridInfo paramEst'];
      
  eval(string_save);
  %save_omni_calib_ascii;
    
  fprintf(1,'done\n');
end


save_name = 'model_parameters';

cont = findSaveName(save_name);
 
fprintf(1,['\nSaving only the parameters under ' save_name '.mat ']);

if cont 
  xi = paramEst.xi;
  kc = paramEst.kc;
  gammac = paramEst.gammac;
  cc = paramEst.cc;
  alpha_c = paramEst.alpha_c;

  if ~paramEst.dioptric
    if ~isfield(borderInfo,'roi_min')
      roi_min = [borderInfo.center_estimate(1)-borderInfo.radius_estimate;borderInfo.center_estimate(2)+borderInfo.radius_estimate];
      roi_max = [borderInfo.center_estimate(1)+borderInfo.radius_estimate;borderInfo.center_estimate(2)-borderInfo.radius_estimate];
    else
      roi_min = borderInfo.roi_min;
      roi_max = borderInfo.roi_max;
    end
  else
    roi_min = [0;0];
    roi_max = [images.nx;images.ny];
  end

  eval(['save ' save_name ' xi kc gammac cc alpha_c roi_min roi_max']);

  write_params_to_file([save_name '.bin'],xi, kc, gammac, cc, alpha_c, roi_min, roi_max);

  fprintf(1,'done\n');
end
