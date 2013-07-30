%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                       %
%   Extract grid corners manually                       %
%                                                       %
%   Created : 2012 (mod 13/07/06)                       %
%   Author : Zhejiang Provincial Key Laboratory of      %
%                Information Network Technology         %
%                      Zhejiang University              %
%                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data_analysis(paramEst, paramEst3D)

ima_num = size(paramEst.Qw,2);
ima_analysis = input('Image(s) to analysis ([] = last three) : ');
if isempty(ima_analysis)
  ima_analysis = (ima_num-2: ima_num);
end
if(size(ima_analysis,2) ~= 3)
      disp('the image number must be 3');
      return
end

ima1 = ima_analysis(1);
ima2 = ima_analysis(2);
ima3 = ima_analysis(3);

paramEst_err = 0;
paramEst_err_std = 0;
paramEst3D_err = 0;
paramEst3D_err_std = 0;
fprintf(1,'paramEst\nparamEst3D\n');


[angle angle_error] = angle_error_cal(paramEst, ima1, ima2);
paramEst_err = paramEst_err + abs(angle - 90);
paramEst_err_std = paramEst_err_std + angle_error;

[angle angle_error] = angle_error_cal(paramEst3D, ima1, ima2);
paramEst3D_err = paramEst3D_err + abs(angle - 90);
paramEst3D_err_std = paramEst3D_err_std + angle_error;
fprintf(1,'\n');


[angle angle_error] = angle_error_cal(paramEst, ima2, ima3);
paramEst_err = paramEst_err + abs(angle - 90);
paramEst_err_std = paramEst_err_std + angle_error;
[angle angle_error] = angle_error_cal(paramEst3D, ima2, ima3);
paramEst3D_err = paramEst3D_err + abs(angle - 90);
paramEst3D_err_std = paramEst3D_err_std + angle_error;
fprintf(1,'\n');

[angle angle_error] = angle_error_cal(paramEst, ima3, ima1);
paramEst_err = paramEst_err + abs(angle - 90);
paramEst_err_std = paramEst_err_std + angle_error;
[angle angle_error] = angle_error_cal(paramEst3D, ima3, ima1);
paramEst3D_err = paramEst3D_err + abs(angle - 90);
paramEst3D_err_std = paramEst3D_err_std + angle_error;
fprintf(1,'\n');

fprintf(1,'paramEst_err  = %f +-%f\n ', paramEst_err / 3, paramEst_err_std / 3);
fprintf(1,'paramEst3D_err  = %f +-%f\n ', paramEst3D_err / 3, paramEst3D_err_std / 3);
