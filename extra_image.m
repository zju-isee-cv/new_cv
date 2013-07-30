%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This bit of code is used to estimate the errors on an extra
% "validation" grid that hasn't been used for the calibration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

extra_image_index = 7;
sindex = num2str(extra_image_index);

if ~exist('alpha_c'),
   alpha_c = 0;
end;

if ~exist('fc')
  disp(['You must calibration before' ...
	' calculating the error for the extra image.']);
  return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We start by recomputing the extrinsic parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KK_extrinsic= [fc(1) alpha_c*fc(1) cc(1);
	       0 fc(2) cc(2);
	       0 0 1];

eval(['X_kk = X_' sindex ';']);
eval(['x_kk = x_' sindex ';']);

[Qw,Tw]=fastOmniPnPBiased(-X_kk, x_kk, [Qw_current;Tw_current;param(1:10)], ...
			  mirror_p, mirror_d, ...
			  mirror_type);
eval(['Qw_' sindex ' = Qw;']);
eval(['Tw_' sindex ' = Tw;']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We reproject the patterns on the images, and 
% compute the pixel errors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

V=[Qw;Tw;XI];
    
eval(['x=x_' sindex ';']);
eval(['X=X_' sindex ';']);

xp=omniCamProjection(-X, V, mirror_p, mirror_d, mirror_type);

part_ex=xp-x;

eval(['y_' sindex ' = xp;'])
eval(['ex_' sindex ' = part_ex;']);

err_mean_abs_extra = mean(abs(part_ex),2)
err_std_abs_extra = std(abs(part_ex),0,2)
err_std_extra = std(part_ex')'
