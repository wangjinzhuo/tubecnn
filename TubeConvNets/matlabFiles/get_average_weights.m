clear; clc;

load('weights_orig.mat'); % weights_orig

copy_num = 15;

size = size(weights_orig);
width_num = size(1);
height_num = size(2);
channel_num = size(3);
kernel_num = size(4);

average_weights = zeros(width_num, height_num, copy_num, kernel_num, 'single');
channel_sum = zeros(width_num, height_num, 1, kernel_num, 'single');

for channel_index = 1 : channel_num
    channel_sum = channel_sum + weights_orig(:, :, channel_index, :);
end

average_weight = channel_sum / channel_num;

for copy_index = 1 : copy_num
    average_weights(:, :, copy_index, :) = average_weight;
end

save average_weights.mat average_weights;