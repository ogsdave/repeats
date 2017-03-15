function [] = test()
greedy_repeats_init();

% listA = {'226148941_00d29de16b_o.jpg'};
% listA = { 'SY_darts.jpg' };
%listA = { 'fairey2.png' };
%listA = { 'wp006.png' };
%listA = { 'sett4.jpg' };
% listA = { '2063499388_567bd68634_o.jpg' };
% listA = { 'two_planes.jpg' };
%listA = {'rhino1.jpg'};
%listA = {'crochet9.png'};
%listA = {'crochet.png'};
%listA = {'crochet-011.jpg'};
%listA = {'building_us.jpg'};
%listA = { 'calib_prague3.jpg' };
% listA = {'circular_window.png'};
%listA = {'PSWT12.JPG'};
%listA = {'kitkat.jpg'};
%listA  = {'OLD_rot_001.jpg'};
%listA  = {'wall.jpg'};
%listA = {'EsherA.jpg'};
%listA = { 'DSC_0810.jpg' }
%listA = { 'fireengine1.jpg' };
listA = {'liz_taylor.jpg'};
%listA = {'object0149.view01.png'};
%listA = {'lviv5.jpg'};
%listA = {'minnesota-tennis-courts-aerial.jpg'}
%listA = {'img_3303.jpg'}
%listA = { 'prague91.jpg' };
%listA = { 'prague23.jpg' };
%listA = { 'wall.jpg' };

imparams = { 'img_set', 'dggt', ...
             'img_names', { listA{:} }, ...
             'max_num_cores', 1, ...
             'dr_type','mser', ...
             'res_path','~/cvpr16' };

cache_params = { 'read_cache',true, ...
                 'write_cache',true };

init_dbs(cache_params{:});
cfg = CFG.get(imparams{:});
sqldb = SQL.SqlDb.getObj();
img_set = sqldb.get_img_set(cfg.img_set.img_set, ...
                            cfg.img_set.img_names);
img_metadata = img_set(1);
cid_cache = CASS.CidCache(img_metadata.cid,imparams{:}); 
img = Img('data',cid_cache.get_img(), ...
          'cid',img_metadata.cid, ...
          'url',img_metadata.url);       
dr = get_dr(img,cid_cache, ...
                {'type',cfg.dr.dr_type});
dr = dr(randperm(numel(dr)));

[~,drid2] = ismember([dr(:).drid],unique([dr(:).drid]));
tmp = mat2cell(drid2,1,ones(1,numel(drid2)));
[dr(:).drid] = tmp{:};

gr_params = { 'desc_linkage', 'single', ...
              'desc_cutoff', 150,... 
              'cc', [img.width/2 img.height/2], ...
              'motion_model', 'HG.laf2xN_to_txN', ...
              'img', img.data, ...
              'num_planes', 1 };

[model_list,u_corr_list,stats_list] = greedy_repeats(dr,gr_params{:});

for k = 1:numel(model_list)
    rimg = render_results([dr(:).u],u_corr_list{k},model_list{k},img);
    h = draw_results(img,rimg);
    draw_reconstruction(h(1),u_corr_list{k},model_list{k});
end
