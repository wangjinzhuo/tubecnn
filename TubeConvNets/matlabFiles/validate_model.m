function results = validate_model(pred_func, video_list_file, model_def_file, model_file, mean_file, appendix)
% ***********************************************************
% validate the model you provide
% ***********************************************************

%read the validation file, get the video path and the label
[video_path, video_length, video_label] = textread(video_list_file, '%s %d %d');

video_num = length(video_label); % the number of videos to be tested

% gpu index you want to use
gpu_id = 0;

caffe.reset_all();
caffe.set_mode_gpu();
caffe.set_device(gpu_id);
net = caffe.Net(model_def_file, model_file, 'test');

pos_count = 0;

for i = 1 : video_num
    i
    
    th = tic();
    
    prediction = pred_func(video_path(i), video_length(i), mean_file, net);

    avg_pred{i} = mean(prediction, 2); % average
    [~, label] = max(avg_pred{i}); % the predicted labels count from 1
    label = label - 1; % the record labels count from 0
    
    if label == video_label(i)
        pos_count = pos_count + 1;
    end
    
    t_one_time(i) = toc(th);
end

accuracy = pos_count / video_num;

fprintf('positive count: %d\n', pos_count);
fprintf('total count: %d\n', video_num);
fprintf('accuracy: %d\n\n', accuracy);

total_time = 0;
for i = 1 : length(t_one_time)
    total_time = total_time + t_one_time(i);
end

avg_time = total_time / length(t_one_time);

fprintf('total time: %d\n', total_time);
fprintf('average time: %d\n\n', avg_time);

save label.mat video_label;

save(sprintf('pred_%s.mat', appendix), 'avg_pred');

save(sprintf('results_%s.mat', appendix), 'pos_count', 'accuracy', 'total_time', 'avg_time');

caffe.reset_all();

end