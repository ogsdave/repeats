function [] = make_sensitivity_figs()
[solver_names,solver_list,colormap] = IJCV19.make_solver_list();

src_path = 'ct_sensitivity_20190412.mat';
target_path = '/home/jbpritts/Documents/ijcv19/fig2/';

keyboard;
TEST.make_sensitivity_figs(src_path, ...
                           target_path, ...
                           colormap, 'ct');

TEST.make_cdf_warp_fig(src_path, ...
                       target_path, ...
                       colormap)


%src_path = 'rt_sensitivity_20190309.mat';
%TEST.make_sensitivity_figs(src_path, ...
%                           target_path, ...
%                           colormap,'rt');