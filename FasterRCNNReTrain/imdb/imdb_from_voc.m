function imdb = imdb_from_voc(root_dir, image_set, year, flip)
% imdb = imdb_from_voc(root_dir, image_set, year)
%   Builds an image database for the PASCAL VOC devkit located
%   at root_dir using the image_set and year.
%
%   Inspired by Andrea Vedaldi's MKL imdb and roidb code.

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Ross Girshick
%
% This file is part of the R-CNN code and is available
% under the terms of the Simplified BSD License provided in
% LICENSE. Please retain this notice and LICENSE if you use
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

%imdb.name = 'voc_train_2007'
%imdb.image_dir = '/work4/rbg/VOC2007/VOCdevkit/VOC2007/JPEGImages/'
%imdb.extension = '.jpg'
%imdb.image_ids = {'000001', ... }
%imdb.sizes = [numimages x 2]
%imdb.classes = {'aeroplane', ... }
%imdb.num_classes
%imdb.class_to_id
%imdb.class_ids
%imdb.eval_func = pointer to the function that evaluates detections
%imdb.roidb_func = pointer to the function that returns regions of interest

if nargin < 4
    flip = false;
end

cache_file = ['../imdb/cache/imdb_voc_' year '_' image_set];
if flip
    cache_file = [cache_file, '_flip'];
end
try
    load(cache_file);
catch
    VOCopts = get_voc_opts(root_dir);
    VOCopts.testset = image_set;
    
    imdb.name = ['voc_' year '_' image_set];
    imdb.image_dir = fileparts(VOCopts.imgpath);
    
    imdb.image_ids = textread(sprintf(VOCopts.imgsetpath, image_set), '%s');
    imdb.extension = 'jpg';
    imdb.flip = flip;
    if flip
        %% make the fliped images and save
        image_at = @(i) sprintf('%s/%s.%s', imdb.image_dir, imdb.image_ids{i}, imdb.extension);
        image_at_2 = @(i) sprintf('%s/%s_2.%s', imdb.image_dir, imdb.image_ids{i}, imdb.extension);
        image_at_3 = @(i) sprintf('%s/%s_3.%s', imdb.image_dir, imdb.image_ids{i}, imdb.extension);
        image_at_4 = @(i) sprintf('%s/%s_4.%s', imdb.image_dir, imdb.image_ids{i}, imdb.extension);
        % flip
        flip_image_at = @(i) sprintf('%s/%s_flip.%s', imdb.image_dir, imdb.image_ids{i}, imdb.extension);
        flip_image_at_2 = @(i) sprintf('%s/%s_flip_2.%s', imdb.image_dir, imdb.image_ids{i}, imdb.extension);
        flip_image_at_3 = @(i) sprintf('%s/%s_flip_3.%s', imdb.image_dir, imdb.image_ids{i}, imdb.extension);
        flip_image_at_4 = @(i) sprintf('%s/%s_flip_4.%s', imdb.image_dir, imdb.image_ids{i}, imdb.extension);
        % check if images exist, if not, save images
        for i = 1:length(imdb.image_ids)
            % 4
            if ~exist(image_at_4(i), 'file')
                im = imread(image_at(i));
                imwrite(rot90(im), image_at_4(i));
            end
            % 2
            if ~exist(image_at_2(i), 'file')
                im = imread(image_at(i));
                imwrite(flipud(im), image_at_2(i));
            end
            % 3
            if ~exist(image_at_3(i), 'file')
                im = imread(image_at_4(i));
                imwrite(flipud(im), image_at_3(i));
            end
            % 5
            if ~exist(flip_image_at(i), 'file')
                im = imread(image_at(i));
                imwrite(fliplr(im), flip_image_at(i));
            end
            % 6
            if ~exist(flip_image_at_2(i), 'file')
                im = imread(image_at_2(i));
                imwrite(fliplr(im), flip_image_at_2(i));
            end
            % 7
            if ~exist(flip_image_at_3(i), 'file')
                im = imread(image_at_3(i));
                imwrite(fliplr(im), flip_image_at_3(i));
            end
            % 8
            if ~exist(flip_image_at_4(i), 'file')
                im = imread(image_at_4(i));
                imwrite(fliplr(im), flip_image_at_4(i));
            end
        end
        %% record info
        img_num = length(imdb.image_ids)*8;
        image_ids = imdb.image_ids;
        %
        imdb.image_ids(1:8:img_num) = image_ids;
        imdb.image_ids(2:8:img_num) = cellfun(@(x) [x, '_2'], image_ids, 'UniformOutput', false);
        imdb.image_ids(3:8:img_num) = cellfun(@(x) [x, '_3'], image_ids, 'UniformOutput', false);
        imdb.image_ids(4:8:img_num) = cellfun(@(x) [x, '_4'], image_ids, 'UniformOutput', false);
        imdb.image_ids(5:8:img_num) = cellfun(@(x) [x, '_flip'], image_ids, 'UniformOutput', false);
        imdb.image_ids(6:8:img_num) = cellfun(@(x) [x, '_flip_2'], image_ids, 'UniformOutput', false);
        imdb.image_ids(7:8:img_num) = cellfun(@(x) [x, '_flip_3'], image_ids, 'UniformOutput', false);
        imdb.image_ids(8:8:img_num) = cellfun(@(x) [x, '_flip_4'], image_ids, 'UniformOutput', false);
        % check code
        imdb.flip_from = zeros(img_num, 1);
        imdb.flip_from(5:8:img_num) = 1:2:img_num/4;
    end
    imdb.classes = VOCopts.classes;
    imdb.num_classes = length(imdb.classes);
    imdb.class_to_id = ...
        containers.Map(imdb.classes, 1:imdb.num_classes);
    imdb.class_ids = 1:imdb.num_classes;
    
    % private VOC details
    imdb.details.VOCopts = VOCopts;
    
    % VOC specific functions for evaluation and region of interest DB
    imdb.eval_func = @imdb_eval_voc;
    imdb.roidb_func = @roidb_from_voc;
    imdb.image_at = @(i) ...
        sprintf('%s/%s.%s', imdb.image_dir, imdb.image_ids{i}, imdb.extension);
    
    for i = 1:length(imdb.image_ids)
        tic_toc_print('imdb (%s): %d/%d\n', imdb.name, i, length(imdb.image_ids));
        info = imfinfo(sprintf(VOCopts.imgpath, imdb.image_ids{i}));
        imdb.sizes(i, :) = [info.Height info.Width];
    end
    
    fprintf('Saving imdb to cache...');
    save(cache_file, 'imdb', '-v7.3');
    fprintf('done\n');
end
