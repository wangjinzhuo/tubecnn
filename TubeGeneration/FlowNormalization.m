function res = FlowNormalization(flow) 

    [ht wd] = size(flow);
    f_tmp = reshape(flow, ht*wd, 1);
    f_mean = mean(f_tmp);
    f_var = var(f_tmp);
    f_tmp = (f_tmp-f_mean)./f_var;
    res = reshape(f_tmp, ht, wd);

end