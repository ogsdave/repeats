%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function gt = make_Rt_gt(scene_num,P,q_gt,cc,ccd_sigma)
l = P' \ [0 0 1]';
gt = struct('l', l, ...
            'scene_num', scene_num, ...
            'q', q_gt, 'ccd_sigma', ccd_sigma, ...
            'cc', cc);