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

if ~exist('save_name'),
    save_name = 'Calib_Results';
end;

fprintf(1,'Generating the matlab script file %s.m containing the intrinsic and extrinsic parameters...\n',save_name)

fid = fopen([ save_name '.m'],'wt');

fprintf(fid,'%% Intrinsic and Extrinsic Camera Parameters\n');
fprintf(fid,'%%\n');
fprintf(fid,'%% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.\n');
fprintf(fid,'%% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.\n');
fprintf(fid,'%%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.\n');
fprintf(fid,'%% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/\n');
fprintf(fid,'\n\n');
fprintf(fid,'%%-- Using Mirror\n');
fprintf(fid,'omni = %d;\n',omni);
fprintf(fid,'\n');
fprintf(fid,'%%-- Mirror parameter "sxi":\n');
fprintf(fid,'mirror_sxi = %5.15f;\n',mirror_sxi);
fprintf(fid,'\n');
fprintf(fid,'%%-- Mirror center estimate :\n');
fprintf(fid,'center_estimate = %5.15f;\n',center_estimate);
fprintf(fid,'\n');
fprintf(fid,'%%-- Mirror radius estimate :\n');
fprintf(fid,'radius_estimate = %5.15f;\n',radius_estimate);
fprintf(fid,'\n');
fprintf(fid,'%%-- Mirror diameter "d":\n');
fprintf(fid,'mirror_diam = %5.15f;\n',mirror_diam);
fprintf(fid,'\n');
fprintf(fid,'%%-- Mirror parameter:\n');
fprintf(fid,'sxi = %5.15f;\n',sxi);
fprintf(fid,'\n');
fprintf(fid,'%%-- Focal length:\n');
fprintf(fid,'gammac = [ %5.15f ; %5.15f ];\n',gammac);
fprintf(fid,'\n');
fprintf(fid,'%%-- Principal point:\n');
fprintf(fid,'cc = [ %5.15f ; %5.15f ];\n',cc);
fprintf(fid,'\n');
fprintf(fid,'%%-- Skew coefficient:\n');
fprintf(fid,'alpha_c = %5.15f;\n',alpha_c);
fprintf(fid,'\n');
fprintf(fid,'%%-- Distortion coefficients:\n');
fprintf(fid,'kc = [ %5.15f ; %5.15f ; %5.15f ; %5.15f ; %5.15f ];\n',kc);
fprintf(fid,'\n');
fprintf(fid,'%%-- Focal length uncertainty:\n');
fprintf(fid,'gammac_error = [ %5.15f ; %5.15f ];\n',gammac_error);
fprintf(fid,'\n');
fprintf(fid,'%%-- Principal point uncertainty:\n');
fprintf(fid,'cc_error = [ %5.15f ; %5.15f ];\n',cc_error);
fprintf(fid,'\n');
fprintf(fid,'%%-- Skew coefficient uncertainty:\n');
fprintf(fid,'alpha_c_error = %5.15f;\n',alpha_c_error);
fprintf(fid,'\n');
fprintf(fid,'%%-- Distortion coefficients uncertainty:\n');
fprintf(fid,'kc_error = [ %5.15f ; %5.15f ; %5.15f ; %5.15f ; %5.15f ];\n',kc_error);
fprintf(fid,'\n');
fprintf(fid,'%%-- Image size:\n');
fprintf(fid,'nx = %d;\n',nx);
fprintf(fid,'ny = %d;\n',ny);
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):\n');
fprintf(fid,'%%-- Those variables are used to control which intrinsic parameters should be optimized\n');
fprintf(fid,'\n');
fprintf(fid,['n_ima = %d;\t\t\t\t\t\t%% Number of calibration' ...
	     ' images\n'],n_ima);
fprintf(fid,['est_xi =  %d;\t\t\t\t\t%% Estimation indicator for' ...
	     ' the mirror parameter xi\n'],est_xi);
fprintf(fid,'est_gammac = [ %d ; %d ];\t\t\t\t\t%% Estimation indicator of the two focal variables\n',est_gammac);
fprintf(fid,'est_aspect_ratio = %d;\t\t\t\t%% Estimation indicator of the aspect ratio gammac(2)/gammac(1)\n',est_aspect_ratio);
fprintf(fid,'center_optim = %d;\t\t\t\t\t%% Estimation indicator of the principal point\n',center_optim);
fprintf(fid,'est_alpha = %d;\t\t\t\t\t\t%% Estimation indicator of the skew coefficient\n',est_alpha);
fprintf(fid,'est_dist = [ %d ; %d ; %d ; %d ; %d ];\t%% Estimation indicator of the distortion coefficients\n',est_dist);
fprintf(fid,'\n\n');
fprintf(fid,'%%-- Extrinsic parameters:\n');
fprintf(fid,'%%-- The rotation quaternion (Qw_kk) and the translation (Tw_kk) vectors for every calibration image and their uncertainties\n');
fprintf(fid,'\n');
for kk = 1:n_ima,
  fprintf(fid,'%%-- Image #%d:\n',kk);
  fprintf(fid,'Qw_%d = [ %d; %d; %d; %d ];\n',kk,Qw_{kk});
  fprintf(fid,'Tw_%d  = [ %d; %d; %d ];\n',kk,Tw_{kk});
  if (exist(['Tw_error_' num2str(kk)])==1) & (exist(['Qw_error_' num2str(kk)])==1),
    eval(['Qw_kk_error = Qw_error_' num2str(kk) ';']);
    eval(['Tw_kk_error = Tw_error_' num2str(kk) ';']);
    fprintf(fid,'Qw_error_%d = [ %d ; %d ; %d ];\n',kk,omckk_error);
    fprintf(fid,'Tw_error_%d  = [ %d ; %d ; %d ];\n',kk,Tckk_error);
  end
  fprintf(fid,'\n');
end

fclose(fid);
