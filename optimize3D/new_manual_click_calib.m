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
function [gridInfo,errorExtr,paramEst3D] = new_manual_click_calib(I,kk,gen_KK_est,gridInfo,paramEst3D)

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


set(2,'color',[1 1 1]);

%%% Added for omni to make it possible to zoom before inputting points
input('Please press enter after zooming...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

title(['Click on the corners of the rectangular pattern (first corner = origin)... Image ' num2str(kk)]);

disp('Click on the corners of the rectangular complete pattern (the first clicked corner is the origin)...');

x= [];y = [];

figure(2); hold on;
for count = 1:4,
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
  
  %% Draw "omni-lines"
  if count>1
    P = omniLinePoints([x(count-1:count)';y(count-1:count)';1,1], ...
		       gen_KK_est,paramEst3D.xi3);
    hold on
    plot(P(1,:),P(2,:),'-','color',[ 1.000 0.314 0.510 ],'linewidth',2);
  end

  drawnow;
end;

%% Draw "omni-lines"
P = omniLinePoints([[x(1);y(1);1],[x(4);y(4);1]],...
		   gen_KK_est,paramEst3D.xi3);
hold on
plot(P(1,:),P(2,:),'-','color',[ 1.000 0.314 0.510 ],'linewidth',2);

drawnow;

hold off;

%[x,y] = ginput3(4);

[Xc,good,bad,type] = cornerfinder([x';y'],I,winty,wintx); % the four corners

x = Xc(1,:)';
y = Xc(2,:)';

%if ~(exist('omni')&omni==1)  
% Sort the corners:
x_mean = mean(x);
y_mean = mean(y);
x_v = x - x_mean;
y_v = y - y_mean;

theta = atan2(-y_v,x_v);
[junk,ind] = sort(theta);

[junk,ind] = sort(mod(theta-theta(1),2*pi));

%ind = ind([2 3 4 1]);

ind = ind([4 3 2 1]); %-> New: the Z axis is pointing uppward

x = x(ind);
y = y(ind);

CC = [gen_KK_est(1,3), gen_KK_est(2,2)];
x_r = x - CC(1);
y_r = y - CC(2);
rs = sqrt(x_r.^2 + y_r.^2);
[mjunk, mind] = min(rs);
p3 = mind;
p4 = mod(mind, 4) +1;
p1 = mod(mind + 1, 4) + 1;
p2 = mod(mind + 2, 4) + 1;
ind = [p1,p2,p3,p4];
x = x(ind);
y = y(ind);


x1= x(1); x2 = x(2); x3 = x(3); x4 = x(4);
y1= y(1); y2 = y(2); y3 = y(3); y4 = y(4);

% Find center:
p_center = cross(cross([x1;y1;1],[x3;y3;1]),cross([x2;y2;1],[x4;y4;1]));
x5 = p_center(1)/p_center(3);
y5 = p_center(2)/p_center(3);

% center on the X axis:
x6 = (x3 + x4)/2;
y6 = (y3 + y4)/2;

% center on the Y axis:
x7 = (x1 + x4)/2;
y7 = (y1 + y4)/2;

% Direction of displacement for the X axis:
vX = [x6-x5;y6-y5];
vX = vX / norm(vX);

% Direction of displacement for the X axis:
vY = [x7-x5;y7-y5];
vY = vY / norm(vY);

% Direction of diagonal:
vO = [x4 - x5; y4 - y5];
vO = vO / norm(vO);

delta = 30;
%end

figure(2); 
if exist('imshow')&exist('uint8')
  imshow(uint8(I));
else
  image(I);
  colormap(gray(256));
end

hold on;

for i=1:4
  if i==4
    P = omniLinePoints([x(4),x(1);y(4),y(1);1,1],gen_KK_est,paramEst3D.xi3);
  else
    P = omniLinePoints([x(i:i+1)';y(i:i+1)';1,1],gen_KK_est,paramEst3D.xi3);
  end
  plot(P(1,:),P(2,:),'g-');
end

plot(x,y,'og');

hx=text(x6 + delta * vX(1) ,y6 + delta*vX(2),'X');
set(hx,'color','g','Fontsize',14);
hy=text(x7 + delta*vY(1), y7 + delta*vY(2),'Y');
set(hy,'color','g','Fontsize',14);
hO=text(x4 + delta * vO(1) ,y4 + delta*vO(2),'O','color','g','Fontsize',14);
hold off;

if 1
    
  n_sq_x = input(['Number of squares along the X direction ([]=' num2str(gridInfo.n_sq_x_default) ') = ']); %6
  n_sq_y = input(['Number of squares along the Y direction ([]=' num2str(gridInfo.n_sq_y_default) ') = ']); %6
  if isempty(n_sq_x), n_sq_x = gridInfo.n_sq_x_default; end;
  if isempty(n_sq_y), n_sq_y = gridInfo.n_sq_y_default; end; 
    
else
  %% TODO %%
  % Try to automatically count the number of squares in the grid
  n_sq_x1 = count_squares(I,x1,y1,x2,y2,wintx);
  n_sq_x2 = count_squares(I,x3,y3,x4,y4,wintx);
  n_sq_y1 = count_squares(I,x2,y2,x3,y3,wintx);
  n_sq_y2 = count_squares(I,x4,y4,x1,y1,wintx);
  
  % If could not count the number of squares, enter manually
  
  if (n_sq_x1~=n_sq_x2)|(n_sq_y1~=n_sq_y2),
    disp('Could not count the number of squares in the grid. Enter manually.');
    n_sq_x = input(['Number of squares along the X direction ([]=' num2str(n_sq_x_default) ') = ']); %6
    n_sq_y = input(['Number of squares along the Y direction ([]=' num2str(n_sq_y_default) ') = ']); %6
    if isempty(n_sq_x), n_sq_x = n_sq_x_default; end;
    if isempty(n_sq_y), n_sq_y = n_sq_y_default; end; 
  else
    n_sq_x = n_sq_x1;
    n_sq_y = n_sq_y1;
  end
end


gridInfo.n_sq_x_default = n_sq_x;
gridInfo.n_sq_y_default = n_sq_y;


if (~exist('dX'))|(~exist('dY')) 
  % This question is now asked only once
  % Enter the size of each square
				     
  dX = input(['Size dX of each square along the X direction ([]=' num2str(gridInfo.dX_default) 'mm) = ']);
  dY = input(['Size dY of each square along the Y direction ([]=' num2str(gridInfo.dY_default) 'mm) = ']);
  if isempty(dX), dX = gridInfo.dX_default; else gridInfo.dX_default = dX; end;
  if isempty(dY), dY = gridInfo.dY_default; else gridInfo.dY_default = dY; end;
    
else
    
  fprintf(1,['Size of each square along the X direction: dX=' num2str(dX) 'mm\n']);
  fprintf(1,['Size of each square along the Y direction: dY=' num2str(dY) 'mm   (Note: To reset the size of the squares, clear the variables dX and dY)\n']);
  %fprintf(1,'Note: To reset the size of the squares, clear the variables dX and dY\n');
    
end;

%%% Added for omni to make it possible to zoom before inputting points
input('Please press enter after zooming...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x= [];y = [];

figure(2); hold on;
% n_sq_x = gridInfo.n_sq_x{kk};
% n_sq_y = gridInfo.n_sq_y{kk};

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

% Compute the inside points through computation of the planar homography (collineation)
Np = (n_sq_x+1)*(n_sq_y+1);
x1 = x(1);y1 = y(1);
x2 = x(n_sq_x+1);y2 = y(n_sq_x+1);
x3 = x(Np-n_sq_x);y3 = y(Np-n_sq_x);
x4 = x(Np);y4 = y(Np);

a00 = [x1;y1;1];
a10 = [x2;y2;1];
a11 = [x3;y3;1];
a01 = [x4;y4;1];

Grid = [dY*n_sq_y dY*n_sq_y  0 0;
	dX*n_sq_x 0 0 dX*n_sq_x;
	0 0 0 0];

V = [1;0.001*ones(6,1);paramEst3D.xi3;zeros(5,1);0;
     gen_KK_est(1,1);gen_KK_est(2,2);
     gen_KK_est(1:2,3)];

 % Compute the transformation
[Qw,Tw] = fastOmniPnP(Grid, [a00(1:2) a10(1:2) a11(1:2) a01(1:2)], V);

% Draw the points of the grid using the new matrices
grid3D = makeGrid(n_sq_x,n_sq_y,dX,dY);


grid_pts = [x,y]';

% Subtract 1 to bring the origin to (0,0) 
% instead of (1,1) in matlab (not necessary in C)
grid_pts = grid_pts - 1; 

ind_corners = [1 n_sq_x+1 (n_sq_x+1)*n_sq_y+1 (n_sq_x+1)*(n_sq_y+1)]; % index of the 4 corners
ind_orig = (n_sq_x+1)*n_sq_y + 1;
xorig = grid_pts(1,ind_orig);
yorig = grid_pts(2,ind_orig);

x_box_kk = [grid_pts(1,:)-(wintx+.5);grid_pts(1,:)+(wintx+.5);grid_pts(1,:)+(wintx+.5);grid_pts(1,:)-(wintx+.5);grid_pts(1,:)-(wintx+.5)];
y_box_kk = [grid_pts(2,:)-(winty+.5);grid_pts(2,:)-(winty+.5);grid_pts(2,:)+(winty+.5);grid_pts(2,:)+(winty+.5);grid_pts(2,:)-(winty+.5)];

figure(3);
if exist('imshow')&exist('uint8')
  imshow(uint8(I));
else
  image(I);
  colormap(gray(256));
end

hold on;

plot(grid_pts(1,:)+1,grid_pts(2,:)+1,'r+','MarkerSize',10);

plot(x_box_kk+1,y_box_kk+1,'-b');
plot(grid_pts(1,ind_corners)+1,grid_pts(2,ind_corners)+1,'mo');
plot(xorig+1,yorig+1,'*m');
xlabel('Xc (in camera frame)');
ylabel('Yc (in camera frame)');
title('Extracted corners');
zoom on;
drawnow;
hold off;

correctExtr = input('Was the extraction successful ? ([]=yes, other=no) : ','s');

if ~isempty(correctExtr)
  % disp(['We will start the manual mode']);
  % omni_manual_extraction;
  disp(['This may come from a bug, please try selecting the points '...
	'in another order (Y then X, counterclockwise...)']);
  errorExtr = 1;
else
  errorExtr = 0;
end

% Arrange the data for output
gridInfo.dX{kk} = dX;
gridInfo.dY{kk} = dY;  

gridInfo.wintx{kk} = wintx;
gridInfo.winty{kk} = winty;

gridInfo.manual_x{kk} = grid_pts;
gridInfo.x{kk} = grid_pts;
gridInfo.X{kk} = grid3D;

gridInfo.n_sq_x{kk} = n_sq_x;
gridInfo.n_sq_y{kk} = n_sq_y;

paramEst3D.Qw{kk} = Qw;
paramEst3D.Tw{kk} = Tw;