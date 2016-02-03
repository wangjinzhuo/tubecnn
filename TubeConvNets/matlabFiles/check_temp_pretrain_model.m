% check the temporal pre-trained model to see if the weights distributed
% over all channels are the same

clear; clc;

model_def_file = '../models/action_recognition/cuhk_action_temporal_vgg_16_flow_deploy.prototxt';
model_file = '../models/action_recognition/vgg_16_action_flow_pretrain.caffemodel';
gpu_id = 0;

caffe.reset_all();
caffe.set_mode_gpu();
caffe.set_device(gpu_id);
net = caffe.Net(model_def_file, model_file, 'test');

weights_temporal = net.params('conv1_1', 1).get_data(); % weights
bias_temporal = net.params('conv1_1', 2).get_data(); % bias

save weights_temporal.mat weights_temporal;
save bias_temporal.mat bias_temporal;

caffe.reset_all();