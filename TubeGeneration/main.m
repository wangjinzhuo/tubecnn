%% 
clear all; close all; clc;

root_img = 'D:\Matlab\opticalFlow_sports\'; % 存放目录
root_flow = 'D:\Matlab\opticalFlow_sports\';
root_rcnn = 'D:\Matlab\wjz_boxes_ucf_sports_vgg_plus_finetune\';
init_num = 30; % 初始处理帧
s_tube = 1/(1+exp(-20))+1/(1+exp(-0.1)); % 确定初始tube阈值
color = {'red', 'purple', 'blue', 'green'};
f_inf = dir(root_rcnn);
fast_th = 0; % 人体检测阈值

for f_idx = 3:length(f_inf)
    f_na = f_inf(f_idx).name; % 文件信息
    s_inf = dir([root_rcnn f_na '\']);
    for s_idx = 3:length(s_inf)
        s_na = s_inf(s_idx).name; % 视频段信息       
        p_inf = dir([root_img f_na '\' s_na '\im\' ]);
        prop_inf = dir([root_rcnn f_na '\' s_na '\']);
        flow_inf = dir([root_img f_na '\' s_na '\of\']);
        flow_len = (length(flow_inf)-2)/2;
        fea_init = [];
        fast_init = []; 
        img_init = [];
        prop_leng = length(prop_inf)-2;
        for p_idx = 1:prop_leng %init_num % 图片信息
            disp(['now process ' f_na ' ' s_na ' ' num2str(p_idx) 'th']);         
            p_name = p_inf(3+p_idx).name;
            img = imread([root_img f_na '\' s_na '\im\' p_name]);  
            flow_xname = flow_inf(2+p_idx).name;
            flow_yname = flow_inf(2+flow_len+p_idx).name;
            flow_x = imread([root_flow f_na '\' s_na '\of\' flow_xname]);
            flow_y = imread([root_flow f_na '\' s_na '\of\' flow_yname]);
            flow(:,:,1) = flow_x;
            flow(:,:,2) = flow_y;          
            prop = load([root_rcnn f_na '\' s_na '\' sprintf('%d',p_idx)  '.mat']);
            prop = BlockTrans(prop.boxes_cell{15});    
%             if p_idx == 28
%                 break_my = 1;
%             end
            [fea_tmp, vec_mot, vec_loc] = FeatureExtraction(img, prop, flow, fast_th); 
            fea_init{1,p_idx} = fea_tmp;
            mot_init{1,p_idx} = vec_mot;
            loc_init{1,p_idx} = vec_loc;
            fast_init{1,p_idx} = prop;
            img_init{1,p_idx} = img;            
        end      
        
        mkdir([root_img f_na '\' s_na '\detectedLoc_hue\']);
        if isempty(fea_init)            
            fid = fopen([root_img f_na '\' s_na '\detectedLoc_hue\result.txt'], 'a');
            fprintf(fid, 'feature extraction failed!');
            fclose(fid);            
            continue;
        end
%         if s_idx == 5
%             mybreak = 1;
%         end
        loc_prop = CentGenerate(fea_init, mot_init, loc_init, s_tube);
        if isempty(loc_prop)
            fid = fopen([root_img f_na '\' s_na '\detectedLoc_hue\result.txt'], 'a');
            fprintf(fid, 'tube generation failed!');
            fclose(fid); 
            continue;
        end
%         tube_res = TubeChoose(loc_prop, fea_init, fast_init, loc_init, img_init);
        tube_final = TubeConnect(loc_prop, img_init);
        save([root_img f_na '\' s_na '\tube_final.mat'],'tube_final');        
        
        mkdir([root_img f_na '\' s_na '\detectedImg_hue\']);
        mkdir([root_img f_na '\' s_na '\faster-rcnn\']);               
        for img_id = 1:prop_leng
            fid = fopen([root_img f_na '\' s_na '\detectedLoc_hue\image_' sprintf('%04d',img_id) '.txt'], 'w');
            fclose(fid);
            img = img_init{img_id};
            fast_t = fast_init{img_id};            
            img_t = img;
            for fast_idx = 1:size(fast_t,1)                
                img_fast = DrawBlockOnImg(img_t, fast_t(fast_idx,:), 'green');  
                img_t = img_fast;
            end
            imwrite(img_t, [root_img f_na '\' s_na '\faster-rcnn\' sprintf('%04d',img_id) '.jpg'], 'jpg');
            loc_pre = [800 800 800 800 800];
            for tub_id = 1:max(size(tube_final))                
                co_idx = color{tub_id};            
                loc_tmp = tube_final{tub_id}{img_id};                
                if ~isempty(loc_tmp)
                    fid = fopen([root_img f_na '\' s_na '\detectedLoc_hue\image_' sprintf('%04d',img_id) '.txt'], 'a');                                       
                    for fid_idx = 1:max(size(loc_tmp))
                        fprintf(fid, '%f ', loc_tmp(fid_idx));                        
                    end       
                    fprintf(fid, '\r\n'); 
                    fclose(fid); 
                    loc_tag = 0;
                    loc_cha = [3,3,3,3,0];
                    if norm(loc_pre-loc_tmp) < 10 % 已经出现过
                        loc_tag = 1;
                        loc_tmp = loc_tmp + loc_cha;
                    end
                    img_det = DrawBlockOnImg(img, loc_tmp, co_idx);
                    img = img_det;
                    if loc_tag == 1
                        loc_pre = loc_tmp-loc_cha;
                    else
                        loc_pre = loc_tmp;
                    end                    
                end             
            end
            imwrite(img, [root_img f_na '\' s_na '\detectedImg_hue\' sprintf('%4d',img_id) '.jpg'], 'jpg');           
        end                   
    end    
end











