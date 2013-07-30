function dPdV=part_omni_j( Xinput, V )
[P,dPdV]=omniCamProjection( Xinput, V );
dPdV = dPdV(:,1:7);
