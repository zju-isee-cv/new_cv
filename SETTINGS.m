% Path to Toolbox directory
toolboxPath =pwd;

% Add paths
path([toolboxPath],path);
path([toolboxPath '\catadioptric'],path);
path([toolboxPath '\imageAnalysis'],path);
path([toolboxPath '\projections'],path);
path([toolboxPath '\optimize3D'],path);
path([toolboxPath '\simplexTools'],path);

clear toolboxPath;

% To get rid of some verbose...
VERS = version;
VERS = VERS(1);

if(VERS=='7')
  warning('off','Images:truesize:imageTooBigForScreen')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Settings for the minimisation         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% General settings for the 'biased' 
% and 'unbiased' calibration
minInfo.taux = 0.001;
minInfo.nu = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Settings for the "Calibration"
minInfo.MaxIterBiased = 60;
% If the extrinsic parameters should
% be recomputed independently
minInfo.recompute_extrinsic_biased = 1;
% How often the extrinsic parameters 
% will be re-estimated
% (does not have any effect
% if recompute_extrinsic_biased = 0)
minInfo.freqRecompExtrBiased = 4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Settings for the "Unbiased calib"
minInfo.MaxIterUnbiased = 60;
% If the extrinsic parameters should
% be recomputed independently
minInfo.recompute_extrinsic_unbiased = 1;
% How often the extrinsic parameters 
% will be re-estimated
% (does not have any effect
% if recompute_extrinsic_unbiased = 0)
minInfo.freqRecompExtrUnbiased = 4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
