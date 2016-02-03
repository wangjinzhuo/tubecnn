clear; clc;

model_def_file = '../models/action_recognition/cuhk_action_spatial_vgg_16_deploy.prototxt';
model_file = '../models/action_recognition/vgg_16_action_rgb_pretrain.caffemodel';

model_new_def_file = '../models/action_recognition/action_20_deploy.prototxt';

gpu_id = 0;

caffe.reset_all();
caffe.set_mode_gpu();
caffe.set_device(gpu_id);
net = caffe.Net(model_def_file, model_file, 'test');

net_new = caffe.Net(model_new_def_file, 'test');

load average_weights.mat; % average_weights

% for each layer, copy parameters
layer_names = net.layer_names;
for i = 1 : length(layer_names)
    layer_names{i}
    % conv1_1
    if strcmp('conv1_1', layer_names{i})
        net_new.params('conv1_1', 1).set_data(average_weights); % set average_weights
        net_new.params('conv1_1', 2).set_data(net.params('conv1_1', 2).get_data()); % set bias
    % else if there exist parameters
    elseif ~isempty(net.layers(layer_names{i}).params)
        blob_size = size(net.layers(layer_names{i}).params);
        for j = 1 : blob_size(2)
            net_new.params(layer_names{i}, j).set_data(net.params(layer_names{i}, j).get_data());
        end
    end    
end

weight_size = size(average_weights);
channel_num = weight_size(3);

net_new.save(sprintf('average_weights_%02d.caffemodel', channel_num));

caffe.reset_all();