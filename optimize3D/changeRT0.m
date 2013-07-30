function [paramEst, paramEst3D] = changeRT0(paramEst, paramEst3D)
paramEst.Q_backup = paramEst.Qw;
paramEst.T_backup = paramEst.Tw;
for i = 1: size(paramEst.Qw,2)
    paramEst.Qw{i} = [1; 0.0001; 0.0001; 0.0001];
    paramEst.Tw{i} = [0.0001; 0.0001; 0.0001];
    paramEst3D.Qw{i} = [1; 0.0001; 0.0001; 0.0001];
    paramEst3D.Tw{i} = [0.0001; 0.0001; 0.0001];
end