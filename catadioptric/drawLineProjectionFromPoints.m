% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation, version 2.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software Foundation,
% Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to obtain the conic matrix of the   %
% projection of a line.                        %
%                                              %
%  Created : 03/03/2005                        %
%   Author : Christopher Mei                   %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%%%
% A,B : points belonging to line
% xi, eta : mirror parameters
% bounded_xi : if 0<=xi<=1 or 0<=xi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Points,C]=drawLineProjectionFromPoints(A,B,xi)

%Number of points to draw between the two points
nbPoints = 20;

infty=0;

N=cross(A,B);
A_proj = spaceToNPlane( A, xi );
B_proj = spaceToNPlane( B, xi );

A_proj(3)=1;
B_proj(3)=1;

%Normalise and impose nz>=0
%N=sign(N(3))*N/norm(N);

if N(3)~=0
  tx=N(1)/N(3);
  ty=N(2)/N(3);
else
  theta=atan2(N(2),N(1));

  disp('radial line : nz=0!');
  %Calculate rhos and angles
  rho_A = sqrt(A_proj(1)^2+A_proj(2)^2);
  theta_A = atan2(A_proj(2),A_proj(1));
  rho_B = sqrt(B_proj(1)^2+B_proj(2)^2);
  theta_B = atan2(B_proj(2),B_proj(1));
  
  %The equation is "singular" so we need to
  %play with the values of rho...
  if theta_A ~= 0
    rho_A = sign(theta_A)*rho_A;
  end
  if theta_B ~= 0
    rho_B = sign(theta_B)*rho_B;
  end
  
  rho_Min=min(rho_A,rho_B);
  rho_Max=max(rho_A,rho_B);
  
  step=(rho_Max-rho_Min)/nbPoints;
  
  rhos=rho_Min:step:rho_Max;
  
  Points=[rhos*cos(theta+pi/2);
	  rhos*sin(theta+pi/2)];
  C=[0;0];
  return
end

%Parameters used to define the line
s=tx^2+ty^2;
xi2=xi^2;
delta=(1-xi2)*s-xi2;

theta=atan2(ty,tx);

C=[-tx/delta;-ty/delta];

%P2=[cos(theta),sin(theta);
%    sin(theta),-cos(theta)]

%Rotation matrix
if s~=0
  P=1/sqrt(s)*[tx,ty,0;
	       ty,-tx,0;
	       0,0,sqrt(s)];
else
  P=eye(3);
end

%Translation matrix
T=[1,0,sqrt(s)/delta;
   0,1,0;
   0,0,1];

%Define numerator and denominator for the polar
%equation of the line
numRho=-sign(delta)*sqrt(s+1)/xi;
partDenomRho=sqrt(s*(1-xi2))/xi;

%Calculate focal distance
c=sign(delta)*sqrt(s*(s+1)*(1-xi2))/delta;

%Move the point projections to the conic reference
%and calculate their corresponding angles
A_proj = T*P*A_proj;
A_proj(1)=A_proj(1)-c;

B_proj = T*P*B_proj;
B_proj(1)=B_proj(1)-c;

theta_A = atan2(A_proj(2),A_proj(1)); %-pi<theta_A<pi
theta_B = atan2(B_proj(2),B_proj(1)); %-pi<theta_B<pi

%Find smallest distance between A and B
diffAB=theta_A-theta_B;

if diffAB>0
  if diffAB>pi
    theta_B = theta_B+2*pi;
  end
else
  if diffAB<-pi
    theta_A = theta_A+2*pi;
  end
end

minTheta=min(theta_A,theta_B);
maxTheta=max(theta_A,theta_B);
step=(maxTheta-minTheta)/nbPoints;

t = minTheta:step:maxTheta;
[lines,cols]=size(t);

Points=[];

for i=1:cols
  rho=numRho/(1+partDenomRho*cos(t(i)));
  %rho=numRho/(1+partDenomRho*cos(t(i)));
  %% TRANSLATE POINTS BACK TO CENTER (Focal points is in (c,0))
  Points=[Points,[rho*cos(t(i))+c;rho*sin(t(i))]];
end

direct = 0;

if direct
  if type~=1
    disp('The direct method is only valid for circles (ie parabolic mirror)')
    return
  end
  Points=Points+C*ones(1,cols);
else
  Points=[Points;ones(1,cols)];
  Points=P'*inv(T)*Points;

  Points=Points*inv(diag(Points(3,:)));
  Points=Points(1:2,:);
  %F=P'*inv(T)*Points*[c;0;1];
end

