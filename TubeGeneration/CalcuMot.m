function res = CalcuMot(flow)

    [ht, wd, dim] = size(flow);
    mat_m = sqrt(flow(:,:,1).^2 + flow(:,:,2).^2);
    res = sum(sum(mat_m))/(ht*wd); 
    
end