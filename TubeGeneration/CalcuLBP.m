function res = CalcuLBP(img)
    
    [ht, wd, dim] = size(img);
    if dim == 3
        img = rgb2gray(img);
    end
    
    ht_n = 2;
    wd_n = 2;
    
    ht_size = floor(ht/ht_n);
    wd_size = floor(wd/wd_n);

    res = extractLBPFeatures(img, 'CellSize', [ht_size, wd_size], 'Upright', false);
end