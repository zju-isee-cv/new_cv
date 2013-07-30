% DIGIPTS2 - digitise points in an image
%
% Function to digitise points in an image.  Points are digitised by clicking
% with the left mouse button.  Clicking any other button terminates the
% function.  Each location digitised is marked with a red '+'.
%
% Usage:  P = digipts3
%
% where P is a 2xn arrays containing the x and y coordinate values digitised in
% the image.
%
% This function uses the cross-hair cursor provided by GINPUT.  This is
% much more useable than IMPIXEL

% It is base on the digipts from :
% Peter Kovesi
% School of Computer Science & Software Engineering
% The University of Western Australia
% pk @ csse uwa edu au
% http://www.csse.uwa.edu.au/~pk
% 
% May 2002

function M = digipts3(nbPoints)
    
    hold on
    M=[];
    but = 1;
    count=0;
    while but == 1 & count ~=nbPoints
      [x y but] = ginput(1);
      if but == 1
	M=[M,[x;y]];
	
	plot(x,y,'r+');
      end
      count=count+1;
    end
    drawnow
    hold off
