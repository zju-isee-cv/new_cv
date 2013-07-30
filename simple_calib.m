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
%    To start calibrating without estimating  %
%              the distortion                 %
%                                             %
%   Created : 2005                            %
%    Author : Christopher Mei                 %
%                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


disp(['Assuming alpha is null, there' ...
      ' is no distortion and the focal values are the same.']);

%Save the values
kc_old = kc;
est_dist_old = est_dist;
est_alpha_old = est_alpha;
est_aspect_ratio_old = est_aspect_ratio;

kc=zeros(5,1)
est_dist = [0;0;0;0;0]
est_alpha = 0
est_aspect_ratio = 0
fc=[KK_estimate(1,1);KK_estimate(2,2)];
cc=[KK_estimate(1:2,3)];

%return

go_omni_calib_optim_iter

%Reload the values
kc = kc_old;
est_dist = est_dist_old;
est_alpha = est_alpha_old;
est_aspect_ratio = est_aspect_ratio_old;

