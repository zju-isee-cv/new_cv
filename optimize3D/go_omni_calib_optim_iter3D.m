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

function [images, paramEst3D] = go_omni_calib_optim_iter3D(minInfo,images,gen_KK_est,gridInfo,paramEst3D)
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
if ~isfield(paramEst3D,'est_dist')
  % Estimate distortion
  paramEst3D.est_dist = [1;1;1;1;0];
%     paramEst.est_dist = [0;0;0;0;0];
end
if ~isfield(paramEst3D,'est_alpha')
  % By default, do not estimate skew
  paramEst3D.est_alpha = 0; 
end
if ~isfield(paramEst3D,'est_gammac')
  % Set to zero if you do not want to estimate 
  % the combined focal length 
  paramEst3D.est_gammac = [1;1];
end
if ~isfield(paramEst3D,'est_aspect_ratio')
  % Aspect ratio
  paramEst3D.est_aspect_ratio = 1;
%      paramEst.est_aspect_ratio = 0;
end
if ~isfield(paramEst3D,'center_optim')
  % Set this variable to 0 if your do 
  % not want to estimate the principal point
  paramEst3D.center_optim = 1;
end

est_xi = paramEst3D.est_xi;
est_dist = paramEst3D.est_dist;
est_alpha = paramEst3D.est_alpha;
est_gammac = paramEst3D.est_gammac;
est_aspect_ratio = paramEst3D.est_aspect_ratio;
center_optim = paramEst3D.center_optim;

nx = images.nx;
ny = images.ny;
n_ima = images.n_ima;

active_images = images.active_images;
ind_active = find(images.active_images);

% Load variables
xi = paramEst3D.xi3;
if isfield(paramEst3D,'kc')
  kc = paramEst3D.kc;
else
    kc = [0;0;0;0;0];
end

if isfield(paramEst3D,'alpha_c')
  alpha_c = paramEst3D.alpha_c;
end
if isfield(paramEst3D,'gammac')
  gammac = paramEst3D.gammac;
end
if isfield(paramEst3D,'cc')
  cc = paramEst3D.cc;
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
  if isempty(paramEst3D.Qw{kk})
    fprintf(1,'Extrinsic parameters at frame %d do not exist\n',kk);
    return
  end
  param(11+7*(kk-1) + 1:11+7*(kk-1) + 7) = [paramEst3D.Qw{kk};paramEst3D.Tw{kk}];
end




%-------------------- Main Optimization: first optimization by my way
fprintf(1, 'optimization by new model\n');
options = optimset('Jacobian','off',...
                    'Display','off',...
                    'Algorithm',{'levenberg-marquardt',.005},...
                    'DerivativeCheck','off',...
                    'Diagnostics', 'on',...
                    'DiffMaxChange', 0.1,...
                    'DiffMinChange', 1e-8,...
                    'FunValCheck', 'on',...
                    'MaxFunEvals', '100*numberOfVariables',...
                    'MaxIter', 400,...
                    'TolFun',1e-6,...
                    'TolX', 1e-6);
param(2:6)=0;
param(7) = 0;
if(isempty('paramEst3D') || ~(isfield(paramEst3D, 'Qw')))
    %initializing the position if not exist
    paramEst3D.Qw = paramEst.Qw;
    paramEst3D.Tw = paramEst.Tw;
end

% if (isempty('paramEst3D') || ~(isfield(paramEst3D,'gammac')))
%     param3D = [1;0;0;0;  0;0;  param];
    paramEst3D.Q = [1;0;0;0];
    paramEst3D.xi1 = 0;
    paramEst3D.xi2 = 0;
    paramEst3D.xi3 = 1;
    paramEst3D.kc = [0;0;0;0;0];
    paramEst3D.alpha_c = 0;
%     paramEst3D.gammac = paramEst.gammac;
    paramEst3D.cc = cc;
    %mask to dicide wich parameter to optimize
    paramEst3D.Q_mask = [0;0;0;0];
    paramEst3D.xi1_mask = 1;
    paramEst3D.xi2_mask = 1;
    paramEst3D.xi3_mask = 1;
    paramEst3D.kc_mask = [1;1;0;0;0];
    paramEst3D.alpha_c_mask = 0;
    paramEst3D.gammac_mask = [1,1];
    paramEst3D.cc_mask = [1,1];
% end

param3D = [paramEst3D.Q;paramEst3D.xi1;paramEst3D.xi2;paramEst3D.xi3;...
        paramEst3D.kc;paramEst3D.alpha_c;paramEst3D.gammac;paramEst3D.cc;zeros(7*n_ima,1)];
 for kk = ind_active
     if isempty(paramEst3D.Qw{kk})
         fprintf(1,'Extrinsic parameters at frame %d do not exist\n',kk);
         return
     end
            param3D(17+7*(kk-1) + 1:17+7*(kk-1) + 7) = [paramEst3D.Qw{kk};paramEst3D.Tw{kk}];
 end 

[solution3D resnorm residual exitflag output lambda jacobian] = lsqnonlin(@(paramO) buildValue3D(n_ima, gridInfo, paramO, ind_active, paramEst3D), param3D, [], [], options);

paramEst3D.pixel_error = residual;
paramEst3D.J = jacobian;
paramEst3D.sigma_x = std(residual);
JaJa3 = jacobian'*jacobian;
paramEst3D.JJ3 = JaJa3;

param3D_error = 3*sqrt(full(diag(pinv(JaJa3))))*(std(residual));
paramEst3D.param3D_error  = param3D_error;

paramEst3D.Q_error =   param3D_error(1:4);
paramEst3D.xi1_error = param3D_error(5);
paramEst3D.xi2_error = param3D_error(6);
paramEst3D.xi3_error = param3D_error(7);
paramEst3D.kc_error = param3D_error(8:12);
paramEst3D.alpha_c_error = param3D_error(13);
paramEst3D.gammac_error = param3D_error(14:15);
paramEst3D.cc_error = param3D_error(16:17);

paramEst3D.Q = solution3D(1:4);
paramEst3D.xi1 = solution3D(5);
paramEst3D.xi2 = solution3D(6);
paramEst3D.xi3 = solution3D(7);
paramEst3D.kc = solution3D(8:12);
paramEst3D.alpha_c = solution3D(13);
paramEst3D.gammac = solution3D(14:15);
paramEst3D.cc = solution3D(16:17);
for kk = ind_active
  %1:length(ind_active)
  %index = ind_active(kk);

%   paramEst3D.Qw{kk} = solution3D(11+7*(kk-1) + 1: 11+7*(kk-1) + 4);
    paramEst3D.Qw{kk} = solution3D(17+7*(kk-1) + 1: 17+7*(kk-1) + 4);
%   paramEst3D.Tw{kk} = solution3D(11+7*(kk-1) + 5: 11+7*(kk-1) + 7);
    paramEst3D.Tw{kk} = solution3D(17+7*(kk-1) + 5: 17+7*(kk-1) + 7);
  
end

[err_mean_abs3D,err_std_abs3D,err_std3D,paramEst3D] = ...
    comp_omni_error3D(images,gen_KK_est,paramEst3D,gridInfo);
paramEst3D.err_mean_abs3D = err_mean_abs3D;
paramEst3D.err_std_abs3D = err_std_abs3D;
paramEst3D.err_std3D = err_std3D;

show_intrinsic3D(paramEst3D,err_mean_abs3D,err_std_abs3D)


