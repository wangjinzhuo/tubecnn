clear;clc;

spatial_pred = load('spatial_pred.mat');
temporal_pred = load('pred_temporal.mat');
label_gt = load('label.mat');


test_num = length(label_gt.video_label);

pos_count = 0;

for i = 1 : test_num
    score_fusion = (spatial_pred.avg_pred{i} + temporal_pred.avg_pred{i} * 2) / 3;
    [~, label] = max(score_fusion); % the predicted labels count from 1
    label = label - 1; % the record labels count from 0
    
    if label == label_gt.video_label(i)
        pos_count = pos_count + 1;
    end
end

fprintf('positive count: %d\n', pos_count);
fprintf('total count: %d\n', test_num);
fprintf('accuracy: %d\n\n', pos_count / test_num);
