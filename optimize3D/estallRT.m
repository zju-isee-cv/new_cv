function [paramEst, paramEst3D] = estallRT(paramEst, gridInfo, gen_KK_est, paramEst3D)


for i = 1: size(gridInfo.x,2)
    [Q, T, R] = estimate_RT(gridInfo.X{i}, gridInfo.x{i}, gen_KK_est(1:2,3), gen_KK_est(1,1));
    
%     Q_real = paramEst.Qw{i};
    paramEst.Qw_est{i} = Q;
    paramEst.Tw_est{i} = T;
    paramEst3D.Qw_est{i} = Q;
    paramEst3D.Tw_est{i} = T;
   % Added by carlos
    paramEst.gammac = [gen_KK_est(1,1); gen_KK_est(2,2)];
    paramEst.cc = gen_KK_est(1:2,3);
%     Q_real = Q_real / norm(Q_real)
%     Q
%     T_real = paramEst.Tw{i}
%     T
%     R_real =  quat2mat(Q_real)
%     R
 end
 