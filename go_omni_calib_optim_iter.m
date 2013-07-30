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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                       %
%      Minimisation function            %
%                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Main calibration function. 
% Computes the intrinsic and extrinsic parameters.
%
% Input: see "click_clib.m"
%
% Output: 
%   adds variables to paramEst structure and modifies estimates
%   for the extrinsic parameters :
%     gammac: Camera focal length
%     cc : Principal point coordinates
%     alpha_c : Skew coefficient
%     kc : Distortion coefficients
%     KK : The camera matrix (containing gammac and cc)
%     Tw : list of extrinsic translation parameters
%     Qw : list of extrinsic rotation parameters
%     y  : point reprojections 
%     ex : list of reprojection errors
%
% Method: Uses the LevenbergMarquardt algorithm to minimise the
%         reprojection error in the least squares sense over the intrinsic
%         camera parameters, and the extrinsic parameters (3D locations of the grids in space)
%
% Note: If the intrinsic camera parameters (gammac, cc, kc) 
%       where initialised thanks to the mirror border extraction.
%
% Note: The row vector active_images consists of zeros and ones. To deactivate an image, set the
%      corresponding entry in the active_images vector to zero.
%

function [paramEst, images] = go_omni_calib_optim_iter(minInfo,images,gen_KK_est,gridInfo,paramEst)
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Minimisation properties
%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('recompute_extrinsic'),
  recompute_extrinsic = 1; % Set this variable to 0 in case you do
                           % not want to recompute the extrinsic parameters
			   % at each iteration.
end

if ~exist('check_cond'),
  check_cond = 1; % Set this variable to 0 in case you don't want to extract view dynamically
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters to estimate
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variables :
% [Qw Tw Dist alpha gamma c];
if ~isfield(images,'desactivated_images')
  images.desactivated_images = [];
end
if ~isfield(paramEst,'est_dist')
  % Estimate distortion
  paramEst.est_dist = [1;1;1;1;0];
%     paramEst.est_dist = [0;0;0;0;0];
end
if ~isfield(paramEst,'est_alpha')
  % By default, do not estimate skew
  paramEst.est_alpha = 0; 
end
if ~isfield(paramEst,'est_gammac')
  % Set to zero if you do not want to estimate 
  % the combined focal length 
  paramEst.est_gammac = [1;1];
end
if ~isfield(paramEst,'est_aspect_ratio')
  % Aspect ratio
  paramEst.est_aspect_ratio = 1;
%      paramEst.est_aspect_ratio = 0;
end
if ~isfield(paramEst,'center_optim')
  % Set this variable to 0 if your do 
  % not want to estimate the principal point
  paramEst.center_optim = 1;
end

est_xi = paramEst.est_xi;
est_dist = paramEst.est_dist;
est_alpha = paramEst.est_alpha;
est_gammac = paramEst.est_gammac;
est_aspect_ratio = paramEst.est_aspect_ratio;
center_optim = paramEst.center_optim;

nx = images.nx;
ny = images.ny;
n_ima = images.n_ima;

active_images = images.active_images;
ind_active = find(images.active_images);

% Load variables
xi = paramEst.xi;
if isfield(paramEst,'kc')
  kc = paramEst.kc;
end
if isfield(paramEst,'alpha_c')
  alpha_c = paramEst.alpha_c;
end
if isfield(paramEst,'gammac')
  gammac = paramEst.gammac;
end
if isfield(paramEst,'cc')
  cc = paramEst.cc;
end

% A quick fix for solving conflict
if ~isequal(est_gammac,[1;1]),
  est_aspect_ratio=1;
end
if ~est_aspect_ratio,
  est_gammac=[1;1];
end

if est_xi
  fprintf(1,'Xi will be estimated (est_xi = 1).\n');
else
  fprintf(1,'Xi will not be estimated (est_xi = 0).\n');
end

if ~est_aspect_ratio,
    fprintf(1,'Aspect ratio not optimized (est_aspect_ratio = 0) -> gammac(1)=gammac(2). Set est_aspect_ratio to 1 for estimating aspect ratio.\n');
else
  if isequal(est_gammac,[1;1]),
    fprintf(1,'Aspect ratio optimized (est_aspect_ratio = 1) -> both components of gammac are estimated (DEFAULT).\n');
  end
end

if ~isequal(est_gammac,[1;1]),
  if isequal(est_gammac,[1;0]),
    fprintf(1,'The first component of focal (gammac(1)) is estimated, but not the second one (est_gammac=[1;0])\n');
  else
    if isequal(est_gammac,[0;1]),
      fprintf(1,'The second component of focal (gammac(1)) is estimated, but not the first one (est_gammac=[0;1])\n');
    else
      fprintf(1,'The focal vector gammac is not optimized (est_gammac=[0;0])\n');
    end
  end
end

if ~center_optim, % In the case where the principal point is not estimated, keep it at the center of the image
  fprintf(1,'Principal point not optimized (center_optim=0). ');
  if ~exist('cc'),
    fprintf(1,'It is kept at the center of the image.\n');
    cc = [(nx-1)/2;(ny-1)/2];
  else
    fprintf(1,'Note: to set it in the middle of the image, clear variable cc, and run calibration again.\n');
  end
else
    fprintf(1,'Principal point optimized (center_optim=1) - (DEFAULT). To reject principal point, set center_optim=0\n');
end


if ~center_optim & (est_alpha),
  fprintf(1,'WARNING: Since there is no principal point estimation (center_optim=0), no skew estimation (est_alpha = 0)\n');
  est_alpha = 0;  
end

if ~est_alpha,
  fprintf(1,'Skew not optimized (est_alpha=0) - (DEFAULT)\n');
  alpha_c = 0;
else
  fprintf(1,'Skew optimized (est_alpha=1). To disable skew estimation, set est_alpha=0.\n');
end



if ~prod(double(est_dist))&exist('kc')
  % If no distortion estimated, set to 
  % zero the variables that are not estimated
  kc = kc .* est_dist;
end


if ~prod(double(est_gammac)),
  fprintf(1,'Warning: The focal length is not fully estimated (est_gammac ~= [1;1])\n');
end

% Put the initial estimates in param
if exist('gammac')
  if ~est_aspect_ratio
    gammac(1) = (gammac(1)+gammac(2))/2;
    gammac(2) = gammac(1);
  end
  XI = [xi;kc;alpha_c;gammac;cc];
else
  gammac = [gen_KK_est(1,1);gen_KK_est(2,2)];
  cc = [gen_KK_est(1:2,3)];
  if ~est_aspect_ratio
    gammac(1) = (gammac(1)+gammac(2))/2;
    gammac(2) = gammac(1);
  end
  % Initialise the distortions with 0 and the other values with
  % the estimation using the mirror border
  XI = [xi;zeros(5,1);0;gammac;cc];
end

%XI

param = [XI;zeros(7*n_ima,1)];

for kk = ind_active
  if isempty(paramEst.Qw{kk})
    fprintf(1,'Extrinsic parameters at frame %d do not exist\n',kk);
    return
  end
  param(11+7*(kk-1) + 1:11+7*(kk-1) + 7) = [paramEst.Qw{kk};paramEst.Tw{kk}];
end

%-------------------- Main Optimization:

fprintf(1,['\nMain calibration optimization procedure - Number of' ...
	   ' images : %d\n'], length(ind_active));



fprintf(1,'Gradient descent iterations : ');

xi = XI(1);
gammac = XI(8:9);
cc = XI(10:11);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Optimisation settings %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
iter = 0;
cond_thresh = 1e-30;

VERS = version;
VERS =  VERS(1);

if(VERS=='7')
  disp(['WARNING: removing singular matrix warning and managing it' ...
	' internally.'])
  warning('off','MATLAB:nearlySingularMatrix')
end
  
emax1 = 1e-10;

taux = minInfo.taux; %DX not clear what does this mean
nu = minInfo.nu;
MaxIterBiased = minInfo.MaxIterBiased;
recompute_extrinsic_biased = minInfo.recompute_extrinsic_biased;
freqRecompExtrBiased = minInfo.freqRecompExtrBiased;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following vector helps to select the 
% variables to update (for only active images):
selected_variables = [est_xi;est_dist;est_alpha;est_gammac;center_optim*ones(2,1);...
		    reshape(ones(7,1)*active_images,7*n_ima,1)];

if ~est_aspect_ratio
  if isequal(est_gammac,[1;1]) | isequal(est_gammac,[1;0])
    selected_variables(9) = 0;
  end
end

ind_Jac = find(selected_variables)';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[sfx,ex3,JJ3] = buildJacobian(n_ima, gridInfo, param, ind_active);  %JJ3 is A=J(x)'J(x), ex3 is g=J(x)'f(x)
%JJ2_inv_old = inv(JJ3);
JJ2_inv_old = pinv(JJ3);

mu = taux*max(max(JJ3));  %¦Ì
found=(max(abs(ex3))<emax1);

do_recomp = 1;

while ~found&(iter<MaxIterBiased)
  fprintf(1,'%d...',iter+1);
  
  if (mu==Inf)|(mu==NaN)
    mu = 1;
  end
  JJ3 = JJ3+mu*eye(size(JJ3,1));

  if rcond(JJ3)<cond_thresh
    disp('Matrix badly conditionned, stopping...')
    break
  end

  if ~est_aspect_ratio & isequal(est_gammac,[1;1]),
    param(9) = param(8);
  end

  %size(JJ3)
  JJ3_old = JJ3;
  ex3_old = ex3;
  
  JJ3 = JJ3(ind_Jac,ind_Jac);
  ex3 = ex3(ind_Jac);
  
  %hlm = -inv(JJ3)*ex3;
  hlm = -pinv(JJ3)*ex3;
  
  param_old = param;
  
  param(ind_Jac) = param(ind_Jac)+hlm;
  sfxp1 = buildValue(n_ima, gridInfo, param, ind_active);
  sFx = norm(sfx)^2;
  sFxp1 = norm(sfxp1)^2;
  
  quote = (sFx-sFxp1)/(0.5*hlm'*(mu*hlm-ex3));
  
  if quote>0
    [sfx,ex3,JJ3] = buildJacobian(n_ima, gridInfo, param, ind_active);
    found=max(abs(ex3))<emax1;
    mu=mu*max(1/3,1-(2*quote-1)^3);
    nu=2;  %¦Í
    do_recomp = 1;
  else
    JJ3 = JJ3_old;
    ex3 = ex3_old;
    param = param_old;
    mu=mu*nu;
    nu=2*nu;
  end
      
  %% Second step: (optional) - It makes convergence faster, and the region of convergence LARGER!!!
  %% Recompute the extrinsic parameters only using compute_extrinsic.m (this may be useful sometimes)
  %% The complete gradient descent method is useful to precisely update the intrinsic parameters.
  
  if recompute_extrinsic&(mod(iter+1,freqRecompExtrBiased)==0) %==0,  
    if do_recomp
      do_recomp = 0;
      fprintf(1,'(r) ');

      for kk = ind_active
	Qw_current = param(11+7*(kk-1) + 1:11+7*(kk-1) + 4);
	Tw_current = param(11+7*(kk-1) + 5:11+7*(kk-1) + 7);
	
	xp = omniCamProjection(gridInfo.X{kk},...
			       [Qw_current; Tw_current;param(1:11)]);
	
	error_init = mean(mean(abs(xp-gridInfo.x{kk}),2));

	[Qw_new,Tw_new,error,k] = fastOmniPnP(gridInfo.X{kk}, gridInfo.x{kk},...
					      [Qw_current;Tw_current;param(1:11)]);
	
	%error
	xp = omniCamProjection(gridInfo.X{kk},[Qw_new;Tw_new;param(1:11)]);
	error_new = mean(mean(abs(xp-gridInfo.x{kk}),2));
	if check_cond
	  if error_new/error_init>5
	    active_images(kk) = 0;
	    fprintf(1,'\nWarning: View #%d is causing problems. This image is now set inactive. (note: to disactivate this option, set check_cond=0)\n',kk);
	    desactivated_images = [desactivated_images kk];
	    Qw_new = NaN*ones(4,1);
	    Tw_new = NaN*ones(3,1); 
	    images.active_images = active_images;
	  end
	end
	param(11+7*(kk-1) + 1:11+7*(kk-1) + 4) = Qw_new;
	param(11+7*(kk-1) + 5:11+7*(kk-1) + 7) = Tw_new;
      end
    end
  end

  iter = iter + 1;    
end

fprintf(1,'done\n');



%%%--------------------------- Computation of the error of estimation:

fprintf(1,'Estimation of uncertainties...');


%check_active_images;

solution = param;

% Extraction of the parameters for computing the right reprojection error:
paramEst.xi = solution(1);
paramEst.kc = solution(2:6);
paramEst.alpha_c = solution(7);
paramEst.gammac = solution(8:9);
paramEst.cc = solution(10:11);

for kk = ind_active
  %1:length(ind_active)
  %index = ind_active(kk);

  paramEst.Qw{kk} = solution(11+7*(kk-1) + 1: 11+7*(kk-1) + 4);
  paramEst.Tw{kk} = solution(11+7*(kk-1) + 5: 11+7*(kk-1) + 7);
  
end

% Recompute the error (in the vector ex):
[err_mean_abs,err_std_abs,err_std,paramEst] = ...
    comp_omni_error(images,gen_KK_est,paramEst,gridInfo);
%comp_omni_sphere_error;

[sfx,ex3,JJ3] = buildJacobian(n_ima, gridInfo, param, ind_active);
JJ3 = JJ3(ind_Jac,ind_Jac);

sigma_x = std(sfx(:));

%param_error = 3*sqrt(full(diag(inv(JJ3))))*sigma_x;
param_error = 3*sqrt(full(diag(pinv(JJ3))))*sigma_x;

index_val = 1;

paramEst.xi_error = NaN;
paramEst.kc_error = NaN*ones(5,1);
paramEst.alpha_c_error = NaN;
paramEst.gammac_error = NaN*ones(2,1);
paramEst.cc_error = NaN*ones(2,1);

if est_xi
  paramEst.xi_error = param_error(1);
  index_val = index_val+1;
end

for i=1:5
  if est_dist(i)
    paramEst.kc_error(i) = param_error(index_val);
    index_val = index_val + 1;
  end
end
if est_alpha
  paramEst.alpha_c_error = param_error(index_val);
  index_val = index_val + 1;
end
for i=1:2
  if est_gammac(i)
    paramEst.gammac_error(i) = param_error(index_val);
    index_val = index_val + 1;
  end
end

if center_optim
  paramEst.cc_error = param_error(index_val:index_val+1);
  index_val = index_val + 2;
end


fprintf(1,'done\n');

show_intrinsic(paramEst,err_mean_abs,err_std_abs);

%%% Some recommendations to the user to reject some of the difficult unkowns... Still in debug mode.

alpha_c_min = paramEst.alpha_c - paramEst.alpha_c_error/2;
alpha_c_max = paramEst.alpha_c + paramEst.alpha_c_error/2;

if (alpha_c_min < 0) & (alpha_c_max > 0)
  fprintf(1,'Recommendation: The skew coefficient alpha_c is found to be equal to zero (within its uncertainty).\n');
  fprintf(1,'                You may want to reject it from the optimization by setting paramEst.est_alpha=0 and run Calibration\n\n');
end

kc_min = paramEst.kc - paramEst.kc_error/2;
kc_max = paramEst.kc + paramEst.kc_error/2;

prob_kc = (kc_min < 0) & (kc_max > 0);

if ~(prob_kc(3) & prob_kc(4))
  prob_kc(3:4) = [0;0];
end


if sum(prob_kc),
  fprintf(1,'Recommendation: Some distortion coefficients are found equal to zero (within their uncertainties).\n');
  fprintf(1,'                To reject them from the optimization set paramEst.est_dist=[%d;%d;%d;%d;%d] and run Calibration\n\n',est_dist & ~prob_kc);
end


return


%function value=gain(hlm,mu,g)
%value=1/2*hlm'*(mu*hlm-g);
