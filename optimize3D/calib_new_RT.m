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
function [gridInfo,  paramEst3D] = calib_new_RT(images, gen_KK_est, gridInfo, paramEst3D)
n_ima = images.n_ima;

fprintf(1,'\nThis function calibrate the other images\n');
ima_numbers = input('Number(s) of image(s) to add ([] = all images) = ');
if isempty(ima_numbers),
  fprintf(1,'All %d images are now active\n',n_ima);
  ima_proc = (n_ima - 2):n_ima;
else
  ima_proc = ima_numbers;
end;

fprintf('\nother images: ');
for i = 1: length(ima_proc)
    fprintf('%d ', ima_proc(i));
end
fprintf('\n');

for i = 1: length(ima_proc)
    ima_number = ima_proc(i)
    V = [paramEst3D.Qw{ima_number}; paramEst3D.Tw{ima_number};paramEst3D.xi3;paramEst3D.kc;paramEst3D.alpha_c;
     paramEst3D.gammac;paramEst3D.cc]; 
    [Q,T] =  fastOmniPnP(gridInfo.X{ima_number}, gridInfo.x{ima_number}, V);
    paramEst3D.Qw{ima_number} = Q;
    paramEst3D.Tw{ima_number} = T;
end

param = [paramEst3D.xi3;paramEst3D.kc;paramEst3D.alpha_c;paramEst3D.gammac;paramEst3D.cc;zeros(7*n_ima,1)];
% ind_active = [1:n_ima];
ind_active = ima_proc;
for kk = ind_active
  if isempty(paramEst3D.Qw{kk})
    fprintf(1,'Extrinsic parameters at frame %d do not exist\n',kk);
    return
  end
  param(11+7*(kk-1) + 1:11+7*(kk-1) + 7) = [paramEst3D.Qw{kk};paramEst3D.Tw{kk}];
end

[sfx,ex3,JJ3, Jout] = buildJacobian(n_ima, gridInfo, param, ind_active);
paramEst3D.J = Jout;

options = optimset('Jacobian','off',...
                    'Algorithm',{'levenberg-marquardt',.005}',...
                    'DerivativeCheck','off',...
                    'Diagnostics', 'on',...
                    'DiffMaxChange', 0.1,...
                    'DiffMinChange', 1e-8,...
                    'Display', 'off',...
                    'FunValCheck', 'on',...
                    'MaxFunEvals', '100*numberOfVariables',...
                    'MaxIter', 400,...
                    'TolFun',1e-6,...
                    'TolX', 1e-6);
                
for i = 1: length(ima_proc)
    ima_number = ima_proc(i)
    if(size(paramEst3D.Qw,2) < ima_number)
        paramEst3D.Qw{ima_number} = paramEst.Qw{ima_number};
        paramEst3D.Tw{ima_number} = paramEst.Tw{ima_number};
    end
    QTparam0 = [paramEst3D.Qw{ima_number}; paramEst3D.Tw{ima_number};];
    systemparam = [paramEst3D.Q;paramEst3D.xi1;paramEst3D.xi2;paramEst3D.xi3;
        paramEst3D.kc;paramEst3D.alpha_c;
        paramEst3D.gammac;paramEst3D.cc]; 
 
    [solutionQT resnorm residual exitflag output lambda jacobian] = lsqnonlin(@(QTparam) buildValue3DforOne(n_ima, gridInfo, QTparam, systemparam, ima_number), QTparam0, [], [], options);
    
    [rj, cj] = size(jacobian);
    start_position_x = 0;
    for k = 1: (ima_number - 1)
            start_position_x =  start_position_x + size((gridInfo.x{k}),2) * 2;
    end
     start_position_x =  start_position_x + 1;
    paramEst3D.J( (start_position_x:  (start_position_x + rj - 1)),17+(ima_number-1)*7+1: 17+(ima_number-1)*7+7) = ...
            jacobian;
    resnorm%%%%%%%%%%%%%%%%%%%%%%%
    paramEst3D.Qw{ima_number} = solutionQT(1:4);
    paramEst3D.Tw{ima_number} = solutionQT(5:7);
end
