function [xdn,G,cspond,cc,P,q_gt,X] = make_reflected_scene()
cfg = struct('nx', 1000, ...
             'ny', 1000, ...
             'cc', [], ...
             'q', -4, ...
             'rigidxform', 't', ...
             'numscenes', 1000, ...
             'ccdsigmalist', [0 0.1 0.5 1 2 5], ...
             'normqlist',-4);

if isempty(cfg.cc)
    cc = [cfg.nx/2+0.5; ...
          cfg.ny/2+0.5];
else
    cc = cfg.cc;
end    

f = 5*rand(1)+3;
cam = CAM.make_ccd(f,4.8,cfg.nx,cfg.ny);
P = PLANE.make_viewpoint(cam);

[X,cspond,G] = PLANE.make_cspond_set_reflect_v(2,10,10);
%[X2,~,G2] = PLANE.make_cspond_set_reflect_v(10,10,10);
%X = [X1 X2];
%G = [G1 G2+max(G1)];

x = RP2.renormI(blkdiag(P,P,P)*X);
q_gt = cfg.q/(sum(2*cc)^2);

xd = CAM.rd_div(reshape(x,3,[]),...
                cam.cc,q_gt);
xdn = reshape(xd,9,[]); 