% 
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                 %
%      Extracts closes points to points           %
%            selected by the user                 %
%                                                 %
%  Created : 16/03/2006                           %
%   Author : Christopher Mei                      %
%                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input :
%   I : image
%   wintx,winty : window size for the point
%                 extraction (5x5 by default)
%
% Output :
%   P : 2xN points precisely extracted
%
function P = precisePoints(I, wintx, winty)

if nargin ~=3
  wintx = 5;
  winty = 5;
end

hold on
P = [];
but = 1;

while but == 1
  [x y but] = ginput(1);
  if but == 1
    [xxi] = cornerfinder([x;y],I,winty,wintx);
    P = [P [xxi(1);xxi(2)]];
    
    plot(xxi(1),xxi(2),'r+','MarkerSize',20);
  end
end

drawnow
hold off
