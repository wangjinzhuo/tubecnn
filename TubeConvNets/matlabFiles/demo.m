clear;clc;

% test video and its optical flow field
video_name = 'v_LongJump_g01_c01.avi';
video_flow = 'test/';

% spatial prediction
model_def_file = '../models/action_recognition/cuhk_action_spatial_vgg_16_deploy.prototxt';
model_file = '../models/action_recognition/cuhk_action_spatial_vgg_16_split1.caffemodel';
% model_file = '../cuhk_action_recognition_vgg_16_split1_rgb_iter_10000.caffemodel';
mean_file = 'rgb_mean.mat';
gpu_id = 0;

caffe.reset_all();
caffe.set_mode_gpu();
caffe.set_device(gpu_id);
net = caffe.Net(model_def_file, model_file, 'test');

spatial_prediction = VideoSpatialPrediction(video_name, mean_file, net);

[maxval, maxpos] = max(spatial_prediction(:));
[label_index, total_frame_index] = ind2sub(size(spatial_prediction), maxpos);

total_frame_index = total_frame_index - 1;
flip_index = floor(total_frame_index / 125); % 0, 1
crop_index = floor((total_frame_index - 125 * flip_index) / 25); %0 - 4
frame_index = total_frame_index - 125 * flip_index - crop_index * 25; % 0 - 24

caffe.reset_all();


% temporal prediction
% model_def_file = 'cuhk_action_temporal_vgg_16_deploy.prototxt';
% model_file = 'cuhk_action_temporal_vgg_16_split1.caffemodel';
% mean_file = 'flow_mean.mat';
% gpu_id = 0;
% 
% caffe.reset_all();
% caffe.set_mode_gpu();
% caffe.set_device(gpu_id);
% net = caffe.Net(model_def_file, model_file, 'test');
% 
% temporal_prediction = VideoTemporalPrediction(video_flow, mean_file, net);
% 
% caffe.reset_all();