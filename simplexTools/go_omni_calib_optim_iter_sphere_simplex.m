
make_all_X;
make_all_x;

%size(param);

buildValueSphere;
%size(sfxp1)

D=fullSphereDistance(param,all_X,all_x,mirror_p,mirror_d, ...
		     mirror_type);
%size(D)
%mean(D-sfxp1)
errorM = D %mean(D)
aX=all_X;
ax=all_x;
mp=mirror_p;
md=mirror_d;
mt=mirror_type;
distfun = @(x) (fullSphereDistance(x,aX,ax,mp,md, mt));
%D2=distfun(param);
%mean(D-D2)
param=fminsearch(distfun,param);
D2=fullSphereDistance(param,all_X,all_x,mirror_p,mirror_d, ...
		      mirror_type);
errorM2= D2 %mean(D2)

solution = param;


% Extraction of the parameters for computing the right reprojection error:
kc_sphere = solution(1:5);
alpha_c_sphere = solution(6);
fc_sphere = solution(7:8);
cc_sphere = solution(9:10);

KK_sphere=[fc_sphere(1) fc_sphere(1)*alpha_c_sphere cc_sphere(1);
	   0 fc_sphere(2) cc_sphere(2);
	   0 0 1];
    
for kk = 1:length(ind_active)
  index = ind_active(kk);

  Qw_kk = solution(10+7*(kk-1) + 1: 10+7*(kk-1) + 4);
  Tw_kk = solution(10+7*(kk-1) + 5: 10+7*(kk-1) + 7);
      
  eval(['Qw_' num2str(index) ' = Qw_kk;']);
  eval(['Tw_' num2str(index) ' = Tw_kk;']);
end;


% Recompute the error (in the vector ex):
comp_omni_error_sphere;

sigma_x = std(ex(:));

param_error =  3*sqrt(full(diag(JJ2_inv)))*sigma_x;

kc_error_sphere = param_error(1:5);
alpha_c_error_sphere = param_error(6);
fc_error_sphere = param_error(7:8);
cc_error_sphere = param_error(9:10);

fprintf(1,'done\n');

show_intrinsic_sphere;

return
