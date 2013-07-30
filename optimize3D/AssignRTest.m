function [paramEst, paramEst3D] = AssignRTest(paramEst, paramEst3D)
paramEst.Q_backup = paramEst.Qw;
paramEst.T_backup = paramEst.Tw;
paramEst.Qw = paramEst.Qw_est;
paramEst.Tw = paramEst.Tw_est;
if(isfield(paramEst3D, 'Qw'))
    paramEst3D.Q_backup = paramEst3D.Qw;
    paramEst3D.T_backup = paramEst3D.Tw;
else
    paramEst3D.Q_backup = paramEst.Qw;
    paramEst3D.T_backup = paramEst.Tw;
end
paramEst3D.Qw = paramEst3D.Qw_est;
paramEst3D.Tw = paramEst3D.Tw_est;