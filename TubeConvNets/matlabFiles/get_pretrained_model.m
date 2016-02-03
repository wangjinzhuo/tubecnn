clear; clc;

model_def_file = '../models/action_recognition/cuhk_action_spatial_vgg_16_deploy.prototxt';
model_file = '../models/action_recognition/vgg_16_action_rgb_pretrain.caffemodel';
gpu_id = 0;

caffe.reset_all();
caffe.set_mode_gpu();
caffe.set_device(gpu_id);
net = caffe.Net(model_def_file, model_file, 'test');

weights_orig = net.params('conv1_1', 1).get_data(); % weights
bias_orig = net.params('conv1_1', 2).get_data(); % bias

save weights_orig.mat weights_orig;
save bias_orig.mat bias_orig;

caffe.reset_all();