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
function [gridInfo,paramEst] = manual_click_ima_calib(I,kk,gen_KK_est,gridInfo,paramEst)

fprintf(1,'\nProcessing image %d...\n',kk);

if isfield(gridInfo,'wintx')&...
      (size(gridInfo.wintx,2)>=kk)&...
      ~isempty(gridInfo.wintx{kk})&...
      ~isnan(gridInfo.wintx{kk})
  wintx = gridInfo.wintx{kk};
  winty = gridInfo.wintx{kk};
else
  wintx = gridInfo.wintx_default;
  winty = gridInfo.winty_default;
end

fprintf(1,'Using (wintx,winty)=(%d,%d) - Window size = %dx%d      (Note: To reset the window size, run script clearwin)\n',...
	wintx,winty,2*wintx+1,2*winty+1);

figure(2);
if exist('imshow')&exist('uint8')
  imshow(uint8(I));
else
  image(I);
  colormap(gray(256));
end
figure(2); hold on;
for points_num =  1: 3
    xi = gridInfo.x{kk}(1,points_num);
    yi = gridInfo.x{kk}(2,points_num);
    plot(xi,yi,'+','color',[ 1.000 0.314 0.510 ],'linewidth',1);
end

set(2,'color',[1 1 1]);
%%% Added for omni to make it possible to zoom before inputting points
input('Please press enter after zooming...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
title(['Click on the corners of the rectangular pattern (first corner = origin)... Image ' num2str(kk)]);
disp('Click on the corners of the rectangular complete pattern (the first clicked corner is the origin)...');
x= [];y = [];
figure(2); hold on;
n_sq_x = gridInfo.n_sq_x{kk};
n_sq_y = gridInfo.n_sq_y{kk};

for count = 1:(n_sq_x+1)*(n_sq_y+1)
  [xi,yi] = ginput3(1);
  [xxi] = cornerfinder([xi;yi],I,winty,wintx);
  
  xi = xxi(1);
  yi = xxi(2);
  figure(2);
  plot(xi,yi,'+','color',[ 1.000 0.314 0.510 ],'linewidth',1);
  plot(xi + [wintx+.5 -(wintx+.5) -(wintx+.5) wintx+.5 wintx+.5],...
       yi + [winty+.5 winty+.5 -(winty+.5) -(winty+.5)  winty+.5],...
       '-','color',[ 1.000 0.314 0.510 ],'linewidth',2);
  
  x = [x;xi];
  y = [y;yi];

  drawnow;
end;
grid_pts = [x,y]';
gridInfo.manual_x{kk} = grid_pts;
