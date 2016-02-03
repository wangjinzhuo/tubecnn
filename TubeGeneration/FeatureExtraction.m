function [res1 res2, res3] = FeatureExtraction(img, prop, flow, th)
        
    flow = single(flow);
    vec_f = [];
    vec_mot = [];
    vec_loc = [];
    [ht wd dim] = size(img);
    ht_f = 256;
    ht_w = 340;    
    %flow(:,:,1) = flow(:,:,1)-128;
    %flow(:,:,2) = flow(:,:,2)-128;
    flow(:,:,1) = FlowNormalization(flow(:,:,1)); % 光流归一化
    flow(:,:,2) = FlowNormalization(flow(:,:,2));
    
    ct = 1;
    for idx = 1:size(prop,1)        
        if prop(idx,end) >= th
            loc = prop(idx,1:end-1); % 方框位置
            %loc = BlockTrans(loc);
            loc = round(loc); loc(1) = max(loc(1),1); loc(2) = max(loc(2),1); loc(3) = min(loc(3),ht); loc(4) = min(loc(4),wd);
            img_p = img(loc(1):loc(3),loc(2):loc(4),:);
            %f_hog = CalcuHoG(img_p);
            f_hue = CalcuHoCWithWeights(img_p);
%             f_rgb = CalcuHoRGB(img_p);
            f_lbp = CalcuLBP(img_p);
            loc_f = [loc(1)*ht_f/ht loc(2)*ht_w/wd loc(3)*ht_f/ht loc(4)*ht_w/wd];
            loc_f = round(loc_f); 
            loc_f(1) = max(loc_f(1),1); loc_f(2) = max(loc_f(2),1); loc_f(3) = min(loc_f(3),ht_f); loc_f(4) = min(loc_f(4),ht_w);
            locf_p = flow(loc_f(1):loc_f(3),loc_f(2):loc_f(4),:);
            f_mot = CalcuMot(locf_p);
            vec_mot(ct,:) = f_mot;
            %vec_f(idx,:) = [f_hog f_hue f_mot];
%             vec_f(idx,:) = [f_hue f_mot];
            vec_f(ct,:) = [f_lbp f_hue];
            vec_loc(ct,:) = [loc prop(idx,end)];
            ct = ct+1;
        end
    end
    
    res1 = vec_f;
    res2 = vec_mot;    
    res3 = vec_loc;
end