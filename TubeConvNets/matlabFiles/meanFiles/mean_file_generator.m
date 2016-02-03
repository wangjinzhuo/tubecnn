clear; clc;

%% generate mat files containning the mean values for testing
mean_value = 10;
width = 224;
height = 224;
channels = 20;

image_mean = ones(width, height, channels, 'single') * mean_value;

save traj_mean.mat image_mean;