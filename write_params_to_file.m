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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
% This function writes into a binary file the focals and %
% principal point coordinates of the KK projection       %
% matrix and the parameters of the mirror.               %
%                                                        %
%                                                        %
%   Created : 2005                                       %
%    Author : Christopher Mei                            %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function write_params_to_file(fileName,xi,kc,gammac,cc,alpha_c,roi_min,roi_max)

fid = fopen(fileName,'w');

fwrite(fid,xi,'double');
fwrite(fid,kc(1),'double');
fwrite(fid,kc(2),'double');
fwrite(fid,kc(3),'double');
fwrite(fid,kc(4),'double');
fwrite(fid,kc(5),'double');
fwrite(fid,gammac(1),'double');
fwrite(fid,gammac(2),'double');
fwrite(fid,cc(1),'double');
fwrite(fid,cc(2),'double');
fwrite(fid,alpha_c,'double');
fwrite(fid,roi_min(1),'double');
fwrite(fid,roi_min(2),'double');
fwrite(fid,roi_max(1),'double');
fwrite(fid,roi_max(2),'double');

fclose(fid);

