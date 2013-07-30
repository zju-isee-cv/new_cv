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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Plots the distribution of the distortion  %
%              in the image                   %
%                                             %
%   Created : 2005                            %
%    Author : Christopher Mei                 %
%                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function distortion_map(I,width,height,f,c,k,alpha,KK_new, mirror_diam)

KK_old=[f(1) alpha*f(1) c(1);
	0 f(2) c(2);
	0 0 1];

KK_new = KK_old;

invKK_new=inv(KK_new);

figure(4)
imshow(I)
hold on

c_e=KK_new*[0;0;1];
r_e=KK_new*[mirror_diam/2;0;0];
r_e=r_e(1)*1.12;

draw2DCircle(c_e,r_e,'r-');
plot(c_e(1),c_e(2),'yx');

width_ones=ones(1,width);

nbNotChanged=0;
nbChanged=0;

A=zeros(height,width);

for i=1:height
  P=[1:width;
     i*width_ones;
     width_ones];

  P = invKK_new*P;
  P = (P(1:2,:)/P(3));
  P = KK_old*[distortion(P,k);width_ones];

  for j=1:width
    if(norm([P(1,j)-c_e(1);P(2,j)-c_e(2)])<r_e)
      A(i,j)=norm([P(1,j)-j;P(2,j)-i]);
      
      if (round(P(1,j))==j)&(round(P(2,j))==i)
	nbNotChanged=nbNotChanged+1;
      else
	nbChanged=nbChanged+1;
      end
    end
  end
end

total = nbChanged+nbNotChanged
disp(['Total not changed : ' num2str((nbNotChanged/total)*100) '%']);
disp(['Total changed : ' num2str((nbChanged/total)*100) '%']);

figure(3);
imagesc(A), colorbar;
axis image
