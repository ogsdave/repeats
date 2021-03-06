%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [model,res,stats_list] = ...
   fit_coplanar_patterns(solver,x,G,K,num_planes,varargin)
ransac = make_ransac(solver,x,G,varargin{:});
[model0,res0,stats_list] = ransac.fit(x,K,G);

guided_search(x,model,cspond,rt,vqT);

ransac.lo.max_iter = 150;
[model,res] =  ransac.lo.fit(x,model0,res0,K,G);

stats_list.local_list(end) = struct('model',model, ...
                                    'res',res, ...
                                    'trial_count',stats_list.local_list(end).trial_count, ...
                                    'model_count',stats_list.local_list(end).model_count);