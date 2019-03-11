function [] = rt_sensitivity()
dstr = datestr(now,'yyyymmdd');
out_name = ['rt_sensitivity_' dstr '.mat'];

nx = 1000;
ny = 1000;
cc = [nx/2+0.5; ...
      ny/2+0.5];

[solver_names,solver_list] = IJCV19.make_solver_list();

TEST.sensitivity(out_name,solver_names([3:7 9]), ...
                 solver_list([3:7 9]), ...
                 solver_names, ...
                 'nx',nx,'ny',ny,'cc',cc, ...
                 'RigidXform','Rt');