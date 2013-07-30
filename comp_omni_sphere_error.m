%%%%%%%%%%%%%%%%%%%% RECOMPUTES THE REPROJECTION ERROR %%%%%%%%%%%%%%%%%%%%%%%%
% This function must only be used after a 'normal' calibration (not
% unbiased). It calculates the error on the sphere.
%

if exist('biased_calib')&~biased_calib
  disp(['Call to this function is only valid after a ''normal''' ...
	' calibration (not unbiased)']);
end


%check_active_images;

% Reproject the patterns on the images, and compute the pixel errors:

ex_sphere = []; % Global error vector

if ~exist('alpha_c'),
   alpha_c = 0;
end;

if ~exist('gammac')
  if exist('gen_KK_estimate')
    XI=[mirror_sxi;zeros(5,1);0;KK_estimate(1,1);KK_estimate(2,2); ...
	KK_estimate(1,3);KK_estimate(2,3)];
  else
    disp(['You must either use "Estimate" or calibration before' ...
	  ' calculating the error']);
    return
  end
else
  XI=[sxi;kc;alpha_c;gammac(1);gammac(2);cc(1);cc(2)];
end

kval=[sxi;kc;alpha_c;gammac;cc];

for kk = 1:length(ind_active)
  index = ind_active(kk);
  
  if active_images(kk) & (~isnan(Qw_{index}(1))),
    V=[Qw_{index};Tw_{index};XI];
    xp=omniCamProjection(X_{index}, V);
    part_ex=sphericalDistanceFromImage(xp,x_{index},kval);
    y_sphere_{index} = xp;
    ex_sphere_{index} = part_ex;
    
    ex_sphere=[ex_sphere part_ex];
  end
end;

err_sphere_mean_abs=mean(abs(ex_sphere),2);
err_sphere_std_abs=std(abs(ex_sphere),0,2);
err_sphere_std = std(ex_sphere')';
