classdef AffPtToDistinctAffPt < Gen
    methods
        function this = AffPtToDistinctAffPt()
        end
    end
       
    methods(Static)
        function res = make(img,cfg_list,laf_list,varargin)
            disp(['DISTINCT regions ' img.url]);                
            res = cell(1,numel(cfg_list));
            for k = 1:numel(cfg_list)
                keepind = LAF.get_distinct(cfg_list{k}, ...
                                           laf_list{k}.affpt);
                res{k}.affpt = laf_list{k}.affpt(keepind);
            end
        end
    end
end
