function res = CentGenerate(ft_cell, mot_cell, loc_cell, num_th)
    
   feat = [];
   mot = [];
   feat_rec = [];
   loc_ft = [];
   ct = 1;
   cell_s = max(size(ft_cell));
   for idx = 1:max(size(ft_cell))
       if isempty(ft_cell{idx})
           continue;
       end
       for ft_idx = 1:size(ft_cell{idx},1)
           feat_rec(ct,:) = [idx ft_idx]; 
           ct = ct+1;
       end
       feat = [feat;ft_cell{idx}];
       mot = [mot;mot_cell{idx}];
       loc_ft = [loc_ft;loc_cell{idx}];
   end
   %opt = statset('emptyaction', 'drop');
   %[lab, cts] = kmeans(feat, num);
   % 伪造敌人
   enermy_num = floor(cell_s * 0.1);
   size_t1 = size(feat);
   size_t2 = size(mot);
   size_t3 = size(loc_ft);
   
   if (size_t1(2) == 0 || size_t2(2) == 0 || size_t3(2) == 0)
       % nothing
       res = [];
       return;
   else
       fake_feat = zeros(enermy_num, size_t1(2));
       fake_mot = zeros(enermy_num, size_t2(2));
       fake_loc_ft = zeros(enermy_num, size_t3(2));
       fake_feat_rec = ones(enermy_num, 2);
       feat = [feat; fake_feat];
       mot = [mot; fake_mot];
       loc_ft = [loc_ft; fake_loc_ft];
       feat_rec = [feat_rec; fake_feat_rec];

       fake_feat = ones(enermy_num, size_t1(2));
       fake_mot = ones(enermy_num, size_t2(2));
       fake_loc_ft = ones(enermy_num, size_t3(2));
       fake_feat_rec = ones(enermy_num, 2);
       feat = [feat; fake_feat];
       mot = [mot; fake_mot];
       loc_ft = [loc_ft; fake_loc_ft];
       feat_rec = [feat_rec; fake_feat_rec];
   end
   
%    loc_res = [];
%    [class,type]=dbscan(feat, cell_s * 0.1); % 最小类至少包含2个元素
   [class,type]=dbscan(feat, 2); % 最小类至少包含2个元素

%    [class, cent_c] = kmeans(feat,3); 
   
   %th = 1/(1+exp(-cell_s*0.4)); %+1/(1+exp(-0.1)); % 确定初始tube阈值
   num_th = cell_s*0.5; % 帧数阈值
   th_optical_flow = 0.1; % 光流阈值
   cla_tmp = unique(class);
   tube_final = [];
   for idx = 1:max(size(cla_tmp))
       loc_tmp = find(class==cla_tmp(idx));
       num_t = length(loc_tmp);
       cet_tmp = sum(feat(loc_tmp,:),1)/num_t;
       %        cet(idx,:) = cet_tmp;    
       sum_mot = sum(mot(loc_tmp))/num_t; % tube 平均光流, mot_cell 存储整个视频光流
       sum_mot_cell(idx,:) = sum_mot;
       %sco_tmp = 1/(1+exp(-num_t)); %+ 1/(1+exp(-sum_mot));
       sco_tmp = num_t;
       sco(idx,:) = sco_tmp;      
                    
       tube_tmp = [];
       locres_tmp = feat_rec(loc_tmp,:);
       locres_tt = unique(locres_tmp(:,1));
       locft_tmp = loc_ft(loc_tmp,:);
       for t_idx = 1:max(size(locres_tt))
           loc_ttt = locres_tt(t_idx);
           locres_r = find(locres_tmp(:,1)==loc_ttt);
           locft_s = locft_tmp(locres_r,:);
           locft_s = sortrows(locft_s,5);
           tube_tmp{1,loc_ttt} = locft_s(end,:);
       end        
       if max(size(tube_tmp)) < cell_s
           for cell_idx = max(size(tube_tmp))+1:cell_s
                tube_tmp{1,cell_idx} = [];
           end
       end
       %%
%        for cell_idx = 1:cell_s
%            if isempty(tube_tmp{1,cell_idx}) && ~isempty(ft_cell{1,cell_idx})
%                ft_add = ft_cell{cell_idx}; 
%                ct_new = repmat(cet_tmp, size(ft_add,1), 1);
%                dis_add = sqrt(sum((ct_new-ft_add).^2,2));
%                loc_add = find(dis_add==min(dis_add));
%                tube_tmp{1,cell_idx} = loc_cell{cell_idx}(loc_add(1),:);               
%            end
%        end
       %%
       tube_final{1,idx} = tube_tmp;     
       %        loc_res{1,idx} = locres_tmp;
   end
   
   loc = find(sum_mot_cell>th_optical_flow);
   if isempty(loc)
       res = [];
       return;
   else
       sco_loc = sco(loc);
       loc = find(sco_loc>num_th);
       if isempty(loc)
            res = [];
            return;
       end       
   end     

%    志豪：
%    loc = find(sum_mot>th_optical_flow); % 光流阈值比较  
%    if isempty(loc)
%        res = [];
%        return;
%    elseif (length(loc) > 1)
%        % 帧数阈值比较
%        loc = find(sco>num_th);
%        if isempty(loc)
%            res = [];
%            return;
%        end
%    end
   
   locfinal = tube_final(loc);
   if max(size(locfinal)) > 3
       locfinal = locfinal(1:3); 
   end
   res = locfinal;
      
%    res = cet(loc,:);           
   
%    for idx = 1:num
%        loc = find(lab==idx);
%        num_t = length(loc);
%        sum_m = sum(feat(loc,end))/num_t;
%        sco(idx,:) = 1/(1+exp(-num_t)) + 1/(1+exp(-sum_m));               
%    end
   
   %save('d:\sco.mat', sco);       
end
