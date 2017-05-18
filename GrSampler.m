classdef GrSampler < handle
    properties
        N,p
        labeling
        
        min_trial_count = 1
        max_trial_count = 1e4
        max_num_retries = 100;
        
        confidence = 0.99

        freq = []
        Z = []
        
        iif = []
    end
    
    methods
        function this = GrSampler(labeling,varargin)
            [this,~] = cmp_argparse(this,varargin{:});

            this.N = numel(labeling);
            this.labeling = labeling;

            this.freq = hist(labeling,1:max(labeling));
            this.Z = arrayfun(@(x) nchoosek(x,2),this.freq);
            this.p = this.Z/sum(this.Z);
            
            this.iif = @(x) make_iif(sum(x > 0) > 0, ...
                                     @() x, ...
                                     true, ...
                                     @() nan(1,numel(x)));
        end

        function num_responses = calc_num_responses(this) 
            num_responses = numel(this.labeling);
        end
            
        function idx = sample(this,dr,k,varargin)
            while true
                t = mnrnd(2,this.p,1);
                indt = find(t);
                c = repelem(indt,t(indt));
                idx1 = find(this.labeling == c(1));
                idx2 = find(this.labeling == c(2));
                idx = [idx1(randperm(numel(idx1),k)) ...
                       idx2(randperm(numel(idx2),k)) ];
                
                if numel(unique(idx)) == 4
                    break
                end
            end
        end
        
        function trial_count = update_trial_count(this,labeling0,cs)
            trial_count = inf;

            cs(cs==0) = nan;
            cs_freq = hist(labeling0.*cs,1:max(labeling0));
            
            ind = cs_freq > 0;

            p2 = hygepdf(2,this.freq(ind),cs_freq(ind),2);
            p3 = dot(this.p(ind),p2);
            
            N = ceil(log(1-this.confidence)/log(1-p3*p3));
            ub = min([N this.max_trial_count]);
            trial_count = max([ub this.min_trial_count]);
        end

    end
end
