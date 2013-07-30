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

function show_intrinsic(paramEst,err_mean_abs,err_std_abs)

if ~isfield(paramEst,'xi_error')
  disp('Launch calibration first');
  return
end

fprintf(1,'\n\nCmei model Calibration results after optimization (with uncertainties):\n\n');
fprintf(1,'Focal Length:      gammac = [ %3.5f   %3.5f ] ¡À [ %3.5f   %3.5f ]\n',[paramEst.gammac;paramEst.gammac_error]);
fprintf(1,'Principal point:       cc = [ %3.5f   %3.5f ] ¡À [ %3.5f   %3.5f ]\n',[paramEst.cc;paramEst.cc_error]);
fprintf(1,'Xi:                    xi = [ %3.5f ] ¡À [ %3.5f ]\n',paramEst.xi,paramEst.xi_error);
fprintf(1,'Skew:             alpha_c = [ %3.5f ] ¡À [ %3.5f  ]   => angle of pixel axes = %3.5f ¡À %3.5f degrees\n',[paramEst.alpha_c;paramEst.alpha_c_error],90 - atan(paramEst.alpha_c)*180/pi,atan(paramEst.alpha_c_error)*180/pi);
fprintf(1,'Distortion:            kc = [ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ] ¡À [ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ]\n',[paramEst.kc;paramEst.kc_error]);   
fprintf(1,'Pixel error+-std :    err = [ %3.5f   %3.5f ]+-[ %3.5f   %3.5f ]\n',err_mean_abs,err_std_abs);
%fprintf(1,'Radian error+-std :         err = [ %3.5f ]+-[ %3.5f ]\n',err_sphere_mean_abs,err_sphere_std_abs);
fprintf(1,'Note: The numerical errors are approximately three times the standard deviations (for reference).\n\n');
