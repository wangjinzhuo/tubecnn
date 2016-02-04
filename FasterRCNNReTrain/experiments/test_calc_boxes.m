clear;clc;close all;
%% test calculating bounding boxes

im_ind = '2008_000073';
append = {'', '_2', '_3', '_4', '_flip', '_flip_2', '_flip_3', '_flip_4'};

% read gt_box
voc_rec = PASreadrecord(sprintf('/home/cnn/faster_rcnn/datasets/VOCdevkit/VOC2012/Annotations/%s.xml', im_ind));
gt_boxes = [];
for i = 1 : length(voc_rec.objects)
    gt_boxes = cat(1, gt_boxes, voc_rec.objects(i).bbox);
end

% calculate and show
for j = 1 : 8
    % load image
    im = imread(sprintf('/home/cnn/faster_rcnn/datasets/VOCdevkit/VOC2012/JPEGImages/%s%s.jpg', im_ind, append{j}));
    %
    gt_boxes_2 = calc_proposals(gt_boxes, voc_rec.imgsize, j);
    figure(j);
    imshow(im);
    linewidth = 2;
    for i = 1 : size(gt_boxes_2, 1)
        rectangle('Position', RectLTRB2LTWH(gt_boxes_2(i, :)), 'LineWidth', linewidth, 'EdgeColor', [0 1 0]);
    end
end