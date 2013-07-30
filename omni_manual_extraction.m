fprintf(1,'Processing image %d...\n',kk);

eval(['I = I_' num2str(kk) ';']);

figure(2); 
if exist('imshow')&exist('uint8')
  imshow(uint8(I));
else
  image(I);
  colormap(map);
end

input('Please press enter after zooming...');

hold on;

fprintf(1,'Grid size is [0..%d]x[0..%d]\n',n_sq_x,n_sq_y);

Xgrid = makeGrid(n_sq_x,n_sq_y);

fprintf(1,'Please select point :\n');

x=zeros(2,(n_sq_x+1)*(n_sq_y+1));

for i=0:n_sq_x
  for j=0:n_sq_y
    fprintf(1,'(%d, %d)', i,j);
    %[Xc,good,bad,type] = cornerfinder([x';y'],I,winty,wintx);
    [xi,yi] = ginput3(1);
    [xxi] = cornerfinder([xi;yi],I,winty,wintx);
    xi = xxi(1);
    yi = xxi(2);
    plot(xi,yi,'+','color',[ 1.000 0.314 0.510 ],'linewidth',1);
    x(1:2,i*(n_sq_y+1)+j+1)=[xi;yi];
  end
end

eval(['X_' num2str(kk) ' = Xgrid;']);
eval(['x_' num2str(kk) ' = x;']);

fprintf(1,'Estimating extrinsic...\n');

V=[1;0.001*ones(6,1);zeros(5,1);0;
   KK_estimate(1,1);KK_estimate(2,2);
   KK_estimate(1:2,3)];

Grid = [n_sq_y n_sq_y  0 0;
	n_sq_x 0 0 n_sq_x;
	0 0 0 0];

a00=x(1:2,n_sq_y+1);
a10=x(1:2,(n_sq_x+1)*(n_sq_y+1));
a11=x(1:2,(n_sq_x)*(n_sq_y+1)+1);
a01=x(1:2,1);

% Compute the transformation
[Qw,Tw]=fastOmniPnPBiased(-Grid, [a00(1:2) a10(1:2) a11(1:2) a01(1:2)], V,...
			  mirror_p, mirror_d, ...
			  mirror_type);

% Translate and rotate points according to parameters
% Do not forget to add a reflection (mirror) 
pts = rigid_motion_quat(-Xgrid,Qw,Tw);

%Project all points according to equations
XX = fastUnifiedPointProjectionK( pts, mirror_p, mirror_d, KK_estimate, mirror_type);

plot(XX(1,:),XX(2,:),'yx');

eval(['Qw_' num2str(kk) ' = Qw;']);
eval(['Tw_' num2str(kk) ' = Tw;']);
