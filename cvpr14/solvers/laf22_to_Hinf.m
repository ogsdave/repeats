function [H,scl] = laf22_to_Hinf(u,G)
v = u;
H = eye(3,3);
for k = 1:1
    [mu,sc] = ...
        cmp_splitapply(@(x) ...
                       (deal({(x(1:2,:)+x(4:5,:)+x(7:8,:))/3}, ...
                             {1./nthroot(LAF.calc_scale(x),3)})),v,G);
    [Hk,scl] = laf2x2_to_Hinf_internal(mu,sc);
    H = Hk*H;
    v = LAF.renormI(blkdiag(H,H,H)*u);
end

function [H,scl] = laf2x2_to_Hinf_internal(aX,arsc)
if ~iscell(aX)
    aX = {aX};
    arsc = {arsc};
end

ALLX = [aX{:}];
ALLX = ALLX(1:2,:);

tx = mean(ALLX(1,:));
ty = mean(ALLX(2,:));
ALLX(1,:) = ALLX(1,:) - tx;
ALLX(2,:) = ALLX(2,:) - ty;
dsc = max(abs(ALLX(:)));

A = eye(3);
A([1,2],3) = -[tx ty] / dsc;
A(1,1) = 1 / dsc;
A(2,2) = 1 / dsc;

len = length(aX);
Z = [];
R = [];

for i = 1:len
    X = aX{i};
    rsc = arsc{i};
    X(1,:) = (X(1,:) - tx) / dsc;
    X(2,:) = (X(2,:) - ty) / dsc;
    z = [rsc .* X(1,:); rsc .* X(2,:)];
    z(len+2, :) = 0;
    z(i+2,:) = -ones(1, size(X,2));
    Z = [Z; z'];
    R = [R; rsc(:)];
end

hs = pinv(Z) * -R;

H = eye(3);
H(3,1) = hs(1);
H(3,2) = hs(2);
H = H * A;

keyboard;

hh = [H(3,1)/H(3,3) H(3,2)/H(3,3)];
scl = (hh*aX{1}+1).^3.*(arsc{1}.^3);
 