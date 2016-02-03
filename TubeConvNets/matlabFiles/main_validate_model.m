clear; clc;

% % test temporal model
% video_list_file = '/home/cnn/caffe-action_recog/examples/action_recognition/dataset_file_examples/val_flow_split1.txt';
% model_def_file = '../models/action_recognition/cuhk_action_temporal_vgg_16_flow_deploy.prototxt';
% model_file = '../models/action_recognition/cuhk_action_temporal_vgg_16_split1.caffemodel';
% mean_file = 'flow_mean.mat';
% 
% pred_func = @VideoTemporalPrediction;
% 
% appendix = 'temporal'; % appendix to files saving results
% 
% validate_model(pred_func, video_list_file, model_def_file, model_file, mean_file, appendix);

% *************************************************************************************************

% test spatial model
video_list_file = '../examples/action_recognition/dataset_file_examples/val_rgb_split1.txt';
model_def_file = '../models/action_recognition/cuhk_action_spatial_vgg_16_deploy.prototxt';
model_file = '../spatialModels/randomFrames/cuhk_action_recognition_vgg_16_split1_rgb_iter_10000.caffemodel';
mean_file = 'meanFiles/rgb_mean.mat';

pred_func = @VideoSpatialPrediction;

appendix = 'spatial'; % appendix to files saving results

validate_model(pred_func, video_list_file, model_def_file, model_file, mean_file, appendix);