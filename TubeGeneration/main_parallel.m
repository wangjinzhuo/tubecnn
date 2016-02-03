% parallel
clear; clc;

root = 'E:\lizhihao';
root_img = [root '\ucf_imgs\']; 
root_flow = [root '\ucf101_flow_img_tvl1_gpu\']; 
root_rcnn = [root '\wjz_boxes_ucf_101_vgg_plus\']; 
root_des = [root '\tube_101_1to40\']; 

% main_thread(16, root_img, root_flow, root_rcnn, root_des);

parpool(40);
parfor i = 1: 40
    main_thread(i + 2, root_img, root_flow, root_rcnn, root_des);
end
delete(gcp);