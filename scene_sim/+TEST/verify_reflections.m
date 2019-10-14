function warp_err = verify_reflections()
solver = WRAP.lafmn_to_qAl(WRAP.laf2_to_ql);
[x,G,cc,P,q_gt,X] = PLANE.make_reflected_scene();
varargin = { 'motion_model', 't' };
[model_list,lo_res_list,stats_list] = ...
    rectify_planes(x,G,solver,cc,varargin{:});
l_gt = P' \ [0 0 1]';
warp_err = TEST.calc_warp_err(reshape(x,3,[]),l_gt,q_gt, ...
                              model_list.l,model_list.q,cc);
display(['Warp error is: ' num2str(warp_err)]);