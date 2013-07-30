function [angle angle_error] = angle_error_cal(paramEst, ima_num1, ima_num2)
ima = size(paramEst.Qw,2);
Q1 = paramEst.Qw{ima_num1};
Q2 = paramEst.Qw{ima_num2};
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
dr13dQ1 = [2*q12, 2*q13, 2*q10, 2*q11;
               -2*q11, -2*q10, 2*q13, 2*q12;
               2*q10, -2*q11, -2*q12, 2*q13];
dQ1dr13 = (pinv(dr13dQ1));

q20 = Q2(1);q21  = Q2(2); q22 = Q1(3); q23 = Q1(4);
dr23dQ2 = [2*q22, 2*q23, 2*q20, 2*q21;
               -2*q21, -2*q20, 2*q23, 2*q22;
               2*q20, -2*q21, -2*q22, 2*q23];
dQ2dr23 = (pinv(dr23dQ2));

dQ1Q2dr3 = [dQ1dr13, zeros(4,3); 
                     zeros(4,3),dQ2dr23];
                 
dcosOdr3 = 1/(norm(r13)*norm(r23))*...
        ([r23(1), r23(2), r23(3), r13(1), r13(2), r13(3)] - ...
         [(r13(1)*r23(1)+r13(2)*r23(2)+r13(3)*r23(3))/((norm(r13))^2)*[r13(1),r13(2),r13(3)],...
            (r13(1)*r23(1)+r13(2)*r23(2)+r13(3)*r23(3))/((norm(r23))^2)*[r23(1), r23(2),r23(3)]]);  
        
dcosOdO = - sin(O);
dOdo = pi/180;
dcosOdo = dcosOdO * dOdo;
dodr3 = (pinv(dcosOdo))*dcosOdr3;
dQ1Q2do = dQ1Q2dr3 * (pinv(dodr3));

dxdo = dxdQ1Q2 *dQ1Q2do;

 JJ = dxdo'*dxdo;
 angle_error= 3*sqrt(full(diag(pinv(JJ))))*(paramEst.sigma_x);
 fprintf(1, 'angleQ%dQ%d: %f+-%f\n',ima_num1, ima_num2, angle, angle_error);