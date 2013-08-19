function paramEst3D = new_est_RT(gridInfo, gen_KK_est, paramEst3D)
for i = 1: size(gridInfo.x,2)
    [Q, T, R] = estimate_RT(gridInfo.X{i}, gridInfo.x{i}, gen_KK_est(1:2,3), gen_KK_est(1,1));
    
%     Q_real = paramEst.Qw{i};
%     paramEst.Qw_est{i} = Q;
%     paramEst.Tw_est{i} = T;
    paramEst3D.Qw_est{i} = Q;
    paramEst3D.Tw_est{i} = T;
   % Added by carlos
    paramEst3D.gammac = [gen_KK_est(1,1); gen_KK_est(2,2)];
    paramEst3D.cc = gen_KK_est(1:2,3);
end
%  paramEst.Qw = paramEst.Qw_est;
%  paramEst.Tw = paramEst.Tw_est;
 paramEst3D.Qw = paramEst3D.Qw_est;
 paramEst3D.Tw = paramEst3D.Tw_est;
disp('Initializing and assigning RT are done');