function res = DrawBlockOnImg(img, loc, co) 
    
    inf = size(img);
    if size(inf,2) == 3
        rgb = img;       
    else        
        rgb(:,:,1) = img;
        rgb(:,:,2) = img;
        rgb(:,:,3) = img;
    end
    
    x_u = max(round(loc(1)),1);
    x_d = max(round(loc(3)),1);
    y_l = max(round(loc(2)),1);
    y_r = max(round(loc(4)),1);

    if strcmp('red', co) 
        rgb(x_u,y_l:y_r,1) = 255;
        rgb(x_u,y_l:y_r,2) = 0;
        rgb(x_u,y_l:y_r,3) = 0;
        
        rgb(x_d,y_l:y_r,1) = 255;
        rgb(x_d,y_l:y_r,2) = 0;
        rgb(x_d,y_l:y_r,3) = 0;
        
        rgb(x_u:x_d,y_l,1) = 255;
        rgb(x_u:x_d,y_l,2) = 0;
        rgb(x_u:x_d,y_l,3) = 0;
        
        rgb(x_u:x_d,y_r,1) = 255;
        rgb(x_u:x_d,y_r,2) = 0;
        rgb(x_u:x_d,y_r,3) = 0;        
    else if strcmp('green', co)
        rgb(x_u,y_l:y_r,1) = 0;
        rgb(x_u,y_l:y_r,2) = 255;
        rgb(x_u,y_l:y_r,3) = 0;
        
        rgb(x_d,y_l:y_r,1) = 0;
        rgb(x_d,y_l:y_r,2) = 255;
        rgb(x_d,y_l:y_r,3) = 0;
        
        rgb(x_u:x_d,y_l,1) = 0;
        rgb(x_u:x_d,y_l,2) = 255;
        rgb(x_u:x_d,y_l,3) = 0;
        
        rgb(x_u:x_d,y_r,1) = 0;
        rgb(x_u:x_d,y_r,2) = 255;
        rgb(x_u:x_d,y_r,3) = 0;  
        else if strcmp('purple', co)
                rgb(x_u,y_l:y_r,1) = 255;
                rgb(x_u,y_l:y_r,2) = 0;
                rgb(x_u,y_l:y_r,3) = 255;

                rgb(x_d,y_l:y_r,1) = 255;
                rgb(x_d,y_l:y_r,2) = 0;
                rgb(x_d,y_l:y_r,3) = 255;

                rgb(x_u:x_d,y_l,1) = 255;
                rgb(x_u:x_d,y_l,2) = 0;
                rgb(x_u:x_d,y_l,3) = 255;

                rgb(x_u:x_d,y_r,1) = 255;
                rgb(x_u:x_d,y_r,2) = 0;
                rgb(x_u:x_d,y_r,3) = 255;    
                else if strcmp('blue', co)     
                        rgb(x_u,y_l:y_r,1) = 0;
                        rgb(x_u,y_l:y_r,2) = 0;
                        rgb(x_u,y_l:y_r,3) = 255;

                        rgb(x_d,y_l:y_r,1) = 0;
                        rgb(x_d,y_l:y_r,2) = 0;
                        rgb(x_d,y_l:y_r,3) = 255;

                        rgb(x_u:x_d,y_l,1) = 0;
                        rgb(x_u:x_d,y_l,2) = 0;
                        rgb(x_u:x_d,y_l,3) = 255;

                        rgb(x_u:x_d,y_r,1) = 0;
                        rgb(x_u:x_d,y_r,2) = 0;
                        rgb(x_u:x_d,y_r,3) = 255;                                                                           
                    end                          
            end
        end
    end
    
    res = rgb;
end