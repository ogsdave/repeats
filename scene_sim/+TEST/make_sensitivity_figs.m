function [] = make_sensitivity_figs(src_path,target_path,colormap,color_list,rigid_xform)
repeats_init();
sensitivity = load(src_path);
is_legend_on = 'Off';

data = innerjoin(sensitivity.res,sensitivity.gt, ...
                 'LeftKeys','ex_num','RightKeys','ex_num');
q_gt = unique(data.q_gt)*sum(2*sum(sensitivity.cam.cc))^2;
assert(numel(q_gt)>0,'Cannot have different distortion parameters');
qres = array2table([data.q*sum(2*sum(sensitivity.cam.cc))^2 ...
                    data.ransac_q*sum(2*sum(sensitivity.cam.cc))^2 ...
                    1-data.q./data.q_gt ...
                    1-data.ransac_q./data.q_gt ...
                    data.rewarp ...
                    data.ransac_rewarp ], ...
                   'VariableNames', ...
                   {'q','ransac_q', 'q_relerr', ...
                    'ransac_q_relerr', 'rewarp','ransac_rewarp'}); 

res = [data(:,{'ex_num','scene_num','solver','sigma'}) qres];
solver_list = unique(res.solver);

Lia = res.sigma > 0;
Lib = ismember(res.solver, ...
               setdiff(solver_list, {'$\mH22\vl s_i$','$\mH22\vl$'}));
Lid = ismember(res.solver,setdiff(solver_list,{'$\mH22\lambda$'}));

lbound = q_gt-4;
ubound = q_gt+4;

axis_options = {'enlargelimits=false'};  
is_valid = Lia & Lib;
boxplot_colors = make_boxplot_colors(res(is_valid,:),color_list,colormap);

ax1 = make_grouped_boxplot(res(is_valid,:), ...
                           {'q'},{ 'sigma', 'solver' }, ...
                           'ylabel', 'Estimated distortion parameter $\hat{ \lambda }$', ...
                           'ylim', [lbound ubound], ...
                           'yticks',[lbound:2:ubound], ...
                           'truth', q_gt, ...
                           'location','northwest', ...
                           'colors', boxplot_colors, ...
                           'legend',is_legend_on);

drawnow;
keyboard;
cleanfigure;
matlab2tikz([target_path sprintf('lambda_sensitivity_%s.tikz',rigid_xform)], ...
             'width', '\fwidth','extraAxisOptions',axis_options);

ax2 = make_grouped_boxplot(res(is_valid,:), ...
                           {'ransac_q'},{ 'sigma','solver' }, ...
                           'ylabel', 'Estimated distortion parameter $\hat{ \lambda }$', ...
                           'ylim', [lbound ubound], ...
                           'yticks',[lbound:2:ubound], ...
                           'truth', q_gt, ...
                           'location','northwest', ...
                           'colors', boxplot_colors, ...
                           'legend',is_legend_on);
drawnow;
cleanfigure;
matlab2tikz([target_path sprintf('ransac_lambda_sensitivity_%s.tikz',rigid_xform)], ...
            'width', '\fwidth','extraAxisOptions',axis_options);

ax3 = make_grouped_boxplot(res(is_valid,:), {'q_relerr'},{ 'sigma', 'solver' }, ...
                           'ylabel', '$(\lambda-\hat{\lambda})/\lambda$', ...
                           'ylim', [-0.6 0.6], ...
                           'yticks',[-0.8:0.2:0.8], ...
                           'truth', 0.0, ...
                           'location','northwest', ...
                           'colors',  boxplot_colors, ...
                           'legend',is_legend_on);
drawnow;
cleanfigure;
matlab2tikz([target_path sprintf('rel_lambda_sensitivity_%s.tikz',rigid_xform)], ...
            'width','\fwidth','extraAxisOptions',axis_options);

ax4 = make_grouped_boxplot(res(is_valid,:), {'ransac_q_relerr'},{ 'sigma', 'solver' }, ...
                           'ylabel', '$(\lambda-\hat{\lambda})/\lambda$', ...
                           'ylim', [-0.6 0.6], ...
                           'yticks',[-0.8:0.2:0.8], ...
                           'truth', 0.0, ...
                           'location','northwest', ...
                           'colors',  boxplot_colors, ...
                           'legend',is_legend_on);
drawnow;
cleanfigure;
matlab2tikz([target_path sprintf('ransac_rel_lambda_sensitivity_%s.tikz',rigid_xform)], ...
            'width', '\fwidth', ...
            'extraAxisOptions',axis_options);

is_valid = Lia & Lid;
boxplot_colors = make_boxplot_colors(res(is_valid,:),color_list,colormap);
ax5 = make_grouped_boxplot(res(is_valid,:), {'rewarp'},{ 'sigma', 'solver'}, ...
                           'ylabel', ['$\Delta^{\mathrm{warp}}_{\' ...
                    'mathrm{RMS}}$ [pixels]'], ...
                           'ylim', [0 40], ...
                           'yticks',[0:10:50], ...
                           'location','northwest', ...
                           'colors', boxplot_colors, ...
                           'legend',is_legend_on);


drawnow;
cleanfigure;
matlab2tikz([target_path sprintf('rewarp_sensitivity_%s.tikz',rigid_xform)],...
            'width', '\fwidth','extraAxisOptions',axis_options);

ax6 = make_grouped_boxplot(res(is_valid,:), {'ransac_rewarp'},{ 'sigma', 'solver'}, ...
                           'ylabel', ['$\Delta^{\mathrm{warp}}_{\' ...
                    'mathrm{RMS}}$ [pixels]'], ...
                           'ylim', [0 40], ...
                           'yticks',[0:10:50], ...
                           'location','northwest', ...
                           'colors', boxplot_colors, ...
                           'legend',is_legend_on);
drawnow;
cleanfigure;
matlab2tikz([target_path sprintf('ransac_rewarp_sensitivity_%s.tikz',rigid_xform)], ...
            'width','\fwidth','extraAxisOptions',axis_options);

function boxplot_colors = make_boxplot_colors(res,colorlist,colormap)
num_solvers = numel(unique(res.solver));
solver_order = cellstr(res(1:num_solvers,:).solver);
boxplot_colors = zeros(num_solvers,3);
for k = 1:num_solvers
    boxplot_colors(k,:) = colorlist(colormap(solver_order{k}),:);
end