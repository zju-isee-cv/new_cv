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
% Calculates the max value between several images %
%                                                 %
%   Created : 2005                                %
%    Author : Christopher Mei                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%  Input  %%%%%%%%%%%%%%%%%%%
% imageList : list of names of images or list of variables

%%%%%%%%%%%%%%%%%%%%%%%  Output  %%%%%%%%%%%%%%%%%%
% max over all the images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nbImages = max(size(listImages));

if nbImages==0
  disp('No images given as input!');
  return
end

% Test if the input is
% LIST_VARS  : a list of variables referring to images
% LIST_NAMES : a list of names of images
LIST_VARS = 1;
LIST_NAMES = 2;

listType = iscell(listImages);

name = char(listImages(1));

if exist(name)
  listType = LIST_VARS;
else
  listType = LIST_NAMES;
end

fprintf(1,[num2str(1) '... ']);

switch listType
 case LIST_VARS
  eval(['currentI = ' name ';']);
 case LIST_NAMES
  currentI = imread(name);
end

I=currentI;

for i=2:nbImages
  name = char(listImages(i));
  switch listType
   case LIST_VARS
    eval(['currentI = ' name ';']);
   case LIST_NAMES
    currentI = imread(name);
  end
  fprintf(1,[num2str(i) '... ']);
  I=max(currentI,I);
end
