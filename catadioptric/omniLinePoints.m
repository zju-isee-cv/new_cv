function P = omniLinePoints(P,KK,xi)

%Use camera projection matrix
P = inv(KK)*P;

%Lift points
P = pointLifting(P, xi);
[P,C] = drawLineProjectionFromPoints(P(:,1),P(:,2),xi);
    
P = KK*[P;ones(1,size(P,2))];
