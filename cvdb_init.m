function [] = cvdb_init()
    [base_path, name, ext] = fileparts(mfilename('fullpath'));
    
    addpath([base_path '/ins']);
    addpath([base_path '/upd']);
    addpath([base_path '/sel']);
    addpath([base_path '/util']);
    addpath([base_path '/serialization']);
    addpath([base_path '/serialization/json']);
    addpath([base_path '/vendor/imagedb']);
    
    javaaddpath([base_path '/vendor/mysql-connector/mysql-connector-' ...
                 'java-5.1.14-bin.jar']);
    javaaddpath([base_path '/vendor/mysql-connector']);

    imagedb_init;