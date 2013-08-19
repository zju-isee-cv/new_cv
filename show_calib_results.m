function show_calib_results(images,gen_KK_est,gridInfo, paramEst3D)

if(exist('paramEst3D') && ~isempty(paramEst3D))
    show_intrinsic3D(paramEst3D,paramEst3D.err_mean_abs3D,paramEst3D.err_std_abs3D);
end


