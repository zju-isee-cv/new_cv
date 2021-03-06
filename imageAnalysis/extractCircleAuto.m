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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                             %
%   Created : 2005                                            %
%    Author : Christopher Mei                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [C_final,r_final]=extractCircleAuto(I, center)

[lines,cols]=size(I);

if nargin==1
  fprintf(1,'Assuming center is at the image center.\n');
  center=[cols/2;lines/2];
  radius_threshold=0.1;
else
  radius_threshold=0.05;
end

if nargout==0
  fprintf(1,'Lauching test mode...\n'); 
  test=1;
else
  test=0;
end

fprintf(1,'Calculating edges... ');
edgeI=edge(I,'sobel');
fprintf(1,'done.\n');

if(test)
  figure(5);
  imshow(edgeI);

  figure(6);
  imshow(uint8(I));
  hold on;

  plot(center(1),center(2),'mo');
end

X=[];
Y=[];

fprintf(1,'Rejecting inner points... ');

est_radius=0;

for i=1:lines
  for j=1:cols
    if edgeI(i,j)~=0
      distToCenter = norm([j;i]-center);
      
      if(distToCenter>est_radius)
	est_radius=distToCenter;
      end
      
      %Remove points between the point and the center
      l_dist=1;
      
      while(l_dist>0.9)
	G=l_dist*[j;i]+(1-l_dist)*center;
	gx=round(G(1));
	gy=round(G(2));
	
	if((edgeI(gy,gx)==1)&gx~=j&gy~=i)
	  edgeI(gy,gx)=0;
	end
	l_dist=l_dist-0.2/distToCenter;
      end
    end
  end
end

if(test)
  figure(7)
  imshow(edgeI);
end

fprintf(1,'Rejecting points inside radius... ');

for i=1:lines
  for j=1:cols
    if edgeI(i,j)~=0
      distToCenter = norm([j;i]-center);

      if(abs(distToCenter-est_radius)>radius_threshold*est_radius)
	edgeI(i,j)=0;
      end
    end
  end
end

if(test)
  figure(8)
  imshow(edgeI);
end

%return
for i=1:lines
  for j=1:cols
    if edgeI(i,j)~=0
      X=[X,j];
      Y=[Y,i];
    end
  end
end

fprintf(1,'done.\n');

C=[];
r=[];

fprintf(1,'Doing a simplified RANSAC to obtain circle parameters... ');

% Sort of ransac, except than
% instead of creating all the model
% the median is used on the parameters
for i=1:60
  [C_c,r_c]=randCircleProps(X,Y);
  C=[C,C_c];
  r=[r;r_c];
end

C_final=median(C,2);
r_final=median(r);

fprintf(1,'done.\n');

if(test)
  figure(6);
  draw2DCircle(C_final,r_final,'r-');
  plot(C_final(1),C_final(2),'yx');
end

function [C,r]=randCircleProps(X,Y)
[lines,nbPoints]=size(X);

T=randTriplet(nbPoints);
[C,r]=circleProps([X(T(1)),Y(T(1));...
		   X(T(2)),Y(T(2));...
		   X(T(3)),Y(T(3))]);

function T=randTriplet(nbPoints)
T=round(rand(3,1)*nbPoints);
if T(1)==0
  T(1)=1;
end
if T(2)==0
  T(2)=1;
end
if T(3)==0
  T(3)=1;
end


function L=makeLine(A)
L=[A(1)^2+A(2)^2, -2*A(1), -2*A(2), 1];

%
% P in the form Nx2
%
function [C,r]=circleProps(P)
%M=[makeLine(A);
%   makeLine(B);
%   makeLine(C)];
[nbPoints,cols]=size(P);

M=[P(:,1).^2+P(:,2).^2,-2*P(:,1),-2*P(:,2),ones(nbPoints,1)];

[U,S,V]=svd(M);
nullV=V(:,4);
nullV=nullV/nullV(1);
C=[nullV(2);nullV(3)];
r=sqrt(nullV(2)^2+nullV(3)^2-nullV(4));
