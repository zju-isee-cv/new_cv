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
%   Projects the points according to the new  %
%             projection model                %
%                                             %
%   Created : 2005                            %
%    Author : Christopher Mei                 %
%                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function check_reproj(I,KK_new,xtr)

%%%% Calculate direct projection of grid %%%%%
x_new=KK_new*[xtr;ones(1,size(xtr,2))];

figure(3);
if exist('imshow','var')&exist('uint8','var')
  imshow(uint8(I));
else
  image(I);
  colormap(map);
end
hold on;

plot(x_new(1,:),x_new(2,:),'m+');

