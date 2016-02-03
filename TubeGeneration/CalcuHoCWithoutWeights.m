function res = CalcuColorHistWithoutWeights(patch) 

    [ht, wd, dim] = size(patch);
    if dim == 1
        res = 0;
        disp('input is gray image, reported from Func CalcuColorHist');
        return;
    end
    p_r = patch(:,:,1);
    p_g = patch(:,:,2);
    p_b = patch(:,:,3);
    hsv = rgb2hsv(p_r, p_g, p_b);
    h_m = reshape(hsv(:,:,1), ht*wd, 1); 
    s_m = reshape(hsv(:,:,2), ht*wd, 1);
    bin_n = 15;    
    hist_h = zeros(1,bin_n);
    
    spa = 1/bin_n;
    for idx = 1:bin_n
        down = (idx-1)*spa;
        up = idx*spa;
        loc = find(h_m>=down & h_m<up);
        if isempty(length(loc)) 
            continue;
        else        
             hist_h(1,idx) = length(loc); 
        end            
    end 
    
    res = hist_h/sum(hist_h);
end