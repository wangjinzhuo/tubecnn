function  res = CalcuHoG(patch)
        
    [ht, wd, col] = size(patch);
    if col == 3
        patch = rgb2gray(patch);
    end  
    patch = single(patch).^0.5; %% 图像灰度平滑     
%     patch = (patch./sqrt(255))*255;
    
    gd_x = patch(2:end,:)-patch(1:end-1,:);
    gd_y = patch(:,2:end)-patch(:,1:end-1);
    gd_x = gd_x(:,1:end-1);
    gd_y = gd_y(1:end-1,:);
    gd_mag = sqrt(gd_x.^2+gd_y.^2);
    ang = atan2(gd_y, gd_x);
    col_row = 3;    %% 划分成3行3列
    col_n = floor((wd-1)/col_row);
    row_n = floor((ht-1)/col_row);
    bin_n = 9;   %% 直方图bin数目
    
    hist_cell = [];
    cell_n = 1;
    for idx = 1:col_row
        for jdx = 1:col_row
            mini_ang = ang((idx-1)*row_n+1:idx*row_n, (jdx-1)*col_n+1:jdx*col_n);
            mini_ang = reshape(mini_ang, col_n*row_n, 1);
            mini_mag = gd_mag((idx-1)*row_n+1:idx*row_n, (jdx-1)*col_n+1:jdx*col_n);
            mini_mag = reshape(mini_mag, col_n*row_n, 1);
            hist_mini = zeros(1,bin_n);
            ang_spa = 2*pi/bin_n;
            for hdx = 1:bin_n
                dn = -pi+(hdx-1)*ang_spa;
                up = -pi+hdx*ang_spa;
                loc = find(mini_ang>=dn & mini_ang<up);
                hist_mini(hdx) = sum(mini_mag(loc));                
            end   
            hist_cell(cell_n,:) = hist_mini;
            cell_n = cell_n+1;
        end
    end
    
    hist_hg = [];    
    for idx = 1:col_row-1
        for jdx = 1:col_row-1            
            loc1= (idx-1)*col_row+jdx;
            loc2= (idx-1)*col_row+jdx+1;
            loc3= idx*col_row+jdx;
            loc4= idx*col_row+jdx+1;
            hist_bk = [hist_cell(loc1,:) hist_cell(loc2,:) hist_cell(loc3,:) hist_cell(loc4,:)];
            hist_bk = hist_bk/norm(hist_bk);
            hist_hg = [hist_hg hist_bk];
        end
    end
    
    res = hist_hg;          
end