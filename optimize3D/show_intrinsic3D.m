function show_intrinsic3D(paramEst3D,err_mean_abs3D,err_std_abs3D)

fprintf(1,'\n\n new model with 3xi\n');
fprintf(1,'Calibration results after optimization (with uncertainties):\n\n');
fprintf(1,'Focal Length:      gammac = [ %3.5f   %3.5f ] ¡À [ %3.5f   %3.5f ]\n',[paramEst3D.gammac;paramEst3D.gammac_error]);
fprintf(1,'Principal point:       cc = [ %3.5f   %3.5f ] ¡À [ %3.5f   %3.5f ]\n',[paramEst3D.cc;paramEst3D.cc_error]);
fprintf(1,'Xi1:                    xi1 = [ %3.5f ] ¡À [ %3.5f ]\n',paramEst3D.xi1,paramEst3D.xi1_error);
fprintf(1,'Xi2:                    xi2 = [ %3.5f ] ¡À [ %3.5f ]\n',paramEst3D.xi2,paramEst3D.xi2_error);
fprintf(1,'Xi3:                    xi3 = [ %3.5f ] ¡À [ %3.5f ]\n',paramEst3D.xi3,paramEst3D.xi3_error);
fprintf(1,'Skew:             alpha_c = [ %3.5f ] ¡À [ %3.5f  ]   => angle of pixel axes = %3.5f ¡À %3.5f degrees\n',[paramEst3D.alpha_c;paramEst3D.alpha_c_error],90 - atan(paramEst3D.alpha_c)*180/pi,atan(paramEst3D.alpha_c_error)*180/pi);
fprintf(1,'Distortion:            kc = [ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ] ¡À [ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ]\n',[paramEst3D.kc;paramEst3D.kc_error]);   
fprintf(1,'Pixel error+-std :    err = [ %3.5f   %3.5f ]+-[ %3.5f   %3.5f ]\n',err_mean_abs3D,err_std_abs3D);
%fprintf(1,'Radian error+-std :         err = [ %3.5f ]+-[ %3.5f ]\n',err_sphere_mean_abs,err_sphere_std_abs);
fprintf(1,'Note: The numerical errors are approximately three times the standard deviations (for reference).\n\n');
