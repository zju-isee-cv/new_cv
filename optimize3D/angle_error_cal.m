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
function [angle angle_error] = angle_error_cal(paramEst, ima_num1, ima_num2, modelname)
ima = size(paramEst.Qw,2);
Q1 = paramEst.Qw{ima_num1};
Qn1 = Q1 / norm(Q1);
Q2 = paramEst.Qw{ima_num2};
Qn2 = Q2 / norm(Q2);
l = size(paramEst.J, 2) ;
Q1_position = (l-(ima-ima_num1) * 7 - 6): (l-(ima-ima_num1)*7 - 3);
Q2_position = (l-(ima-ima_num2) * 7 - 6): (l-(ima-ima_num2)*7 - 3);

dxdQ1Q2 = paramEst.J(:,[Q1_position, Q2_position]);

R1 = quat2mat(Q1);
R2 = quat2mat(Q2);
r13 = R1(:,3);
r23 = R2(:,3);

cosO = r13'*r23/(norm(r13)*norm(r23));
O = acos(cosO);
angle = O/pi*180;


q10 = Q1(1);q11  = Q1(2); q12 = Q1(3); q13 = Q1(4);
dQn1dQ1 = 1 / (norm(Q1))^1.5*[norm(Q1)^2-q10^2, -q10*q11, -q10*q12, -q10*q13;
                                                  -q10*q11, norm(Q1)^2 - q11^2, -q11*q12, -q11*q13;
                                                  -q10*q12, -q11*q12, norm(Q1)^2-q12^2, -q12*q13;
                                                  -q10*q13, -q11*q13, -q12*q13, norm(Q1)^2 - q13^2];
                                              
q20 = Q2(1);q21  = Q2(2); q22 = Q2(3); q23 = Q2(4);
dQn2dQ2 = 1 / (norm(Q2))^1.5*[norm(Q2)^2-q20^2, -q20*q21, -q20*q22, -q20*q23;
                                                  -q20*q21, norm(Q2)^2 - q21^2, -q21*q22, -q21*q23;
                                                  -q20*q22, -q21*q22, norm(Q2)^2-q22^2, -q22*q23;
                                                  -q20*q23, -q21*q23, -q22*q23, norm(Q2)^2 - q23^2];
                                              
dQn1Qn2dQ1Q2 = [dQn1dQ1, zeros(4,4); 
                                zeros(4,4),dQn2dQ2];     
 
dxdQn1Qn2 = dxdQ1Q2 * (pinv(dQn1Qn2dQ1Q2));

q10 = Qn1(1);q11  = Qn1(2); q12 = Qn1(3); q13 = Qn1(4);
dr13dQn1 = [2*q12, 2*q13, 2*q10, 2*q11;
               -2*q11, -2*q10, 2*q13, 2*q12;
               2*q10, -2*q11, -2*q12, 2*q13];
dQn1dr13 = (pinv(dr13dQn1));

q20 = Qn2(1);q21  = Qn2(2); q22 = Qn2(3); q23 = Qn2(4);
dr23dQn2 = [2*q22, 2*q23, 2*q20, 2*q21;
               -2*q21, -2*q20, 2*q23, 2*q22;
               2*q20, -2*q21, -2*q22, 2*q23];
dQn2dr23 = (pinv(dr23dQn2));

dQn1Qn2dr3 = [dQn1dr13, zeros(4,3); 
                        zeros(4,3),dQn2dr23];
                 
dcosOdr3 = 1/(norm(r13)*norm(r23))*...
        ([r23(1), r23(2), r23(3), r13(1), r13(2), r13(3)] - ...
         [(r13(1)*r23(1)+r13(2)*r23(2)+r13(3)*r23(3))/((norm(r13))^2)*[r13(1),r13(2),r13(3)],...
            (r13(1)*r23(1)+r13(2)*r23(2)+r13(3)*r23(3))/((norm(r23))^2)*[r23(1), r23(2),r23(3)]]);  
        
dcosOdO = - sin(O);
dOdo = pi/180;
dcosOdo = dcosOdO * dOdo;
dodr3 = (pinv(dcosOdo))*dcosOdr3;
dQn1Qn2do = dQn1Qn2dr3 * (pinv(dodr3));

dxdo = dxdQn1Qn2 *dQn1Qn2do;

 JJ = dxdo'*dxdo;
 angle_error= 3*sqrt(full(diag(pinv(JJ))))*(paramEst.sigma_x);
 
 fprintf(1, '%s angleQ%dQ%d: %f +- %f\n', modelname, ima_num1, ima_num2, angle, angle_error);