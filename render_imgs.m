function [uimg,rimg,rd_div_line_img,masked_sc_img] = ...
        render_imgs(img,meas,model,res,varargin)
cfg = struct('min_scale', 0.1, ...
             'max_scale', 10 ,...
             'mask', [], ...
             'masked_rd_div_line', true);

[cfg,rectify_settings] = cmp_argparse(cfg,varargin{:});

ind = find(~isnan(model.Gm));
x = reshape(meas.x(:,unique(res.info.cspond(:,res.cs))),3,[]);
l = PT.renormI(transpose(model.H(3,:)));   

uimg = IMG.ru_div(img,model.cc,model.q);

border = IMG.calc_rectification_border(size(img),l, ...
                                       model.cc,model.q, ...
                                       cfg.min_scale,cfg.max_scale,x);
[rimg,trect,tform] = IMG.ru_div_rectify(img,model.H,model.cc,model.q, ...
                                        'cspond', x, 'border', border, ...
                                        'Registration', 'Similarity', ...
                                        rectify_settings{:});
rd_div_line_img = ...
    LINE.render_rd_div(img,model.q,model.cc,model.l);

masked_sc_img = [];
if ~isempty(cfg.mask)
    masked_sc_img = ...
        IMG.render_masked_scale_change(img,meas,model,res,cfg.mask);
    
    if cfg.masked_rd_div_line
        masked_sc_img = ...
            LINE.render_rd_div(masked_sc_img,model.q,model.cc,model.l);
    end
end