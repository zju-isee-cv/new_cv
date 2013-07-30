function show_calib_results(images,gen_KK_est,paramEst,gridInfo, paramEst3D)

if(exist('paramEst3D') && ~isempty(paramEst3D))
    show_intrinsic3D(paramEst3D,paramEst3D.err_mean_abs3D,paramEst3D.err_std_abs3D);
end
    % Recompute the error (in the vector ex):
[err_mean_abs,err_std_abs,err_std,paramEst] = ...
    comp_omni_error(images,gen_KK_est,paramEst,gridInfo);
show_intrinsic(paramEst,err_mean_abs,err_std_abs);

