function res = MeanshiftTracking(img_s, img_t, loc)

    % Similarity Threshold
    f_thresh = 0.16;
    % Number max of iterations to converge
    max_it = 5;
    % Parzen window parameters
    kernel_type = 'Gaussian';
    radius = 1;

    %% Target Selection in Reference Frame
    loc = round(loc);
    x0 = loc(2);
    y0 = loc(1);
    H = loc(3)-loc(1);
    W = loc(4)-loc(2);
    T = img_s(y0:y0+H-1,x0:x0+W-1,:);
    Length = 2;
    [height width dim] = size(img_s);

    %% Run the Mean-Shift algorithm
    % Calculation of the Parzen Kernel window
    [k,gx,gy] = Parzen_window(H,W,radius,kernel_type,0);
    % Conversion from RGB to Indexed colours
    % to compute the colour probability functions (PDFs)
    [I,map] = rgb2ind(img_s,65536);

    % for totally black images
    if size(map, 1) == 1
        res = [];
        return;
    end

    Lmap = length(map)+1;
    T = rgb2ind(T,map);
    % Estimation of the target PDF
    q = Density_estim(T,Lmap,k,H,W,0);
    % Flag for target loss
    loss = 0;
    % Similarity evolution along tracking
    f = zeros(1,(Length-1)*max_it);
    % Sum of iterations along tracking and index of f
    f_indx = 1;

    I2 = rgb2ind(img_t,map);
    % Apply the Mean-Shift algorithm to move (x,y)
    % to the target location in the next frame.
    [x,y,loss,f,f_indx] = MeanShift_Tracking(q,I2,Lmap,...
        height,width,f_thresh,max_it,x0,y0,H,W,k,gx,...
        gy,f,f_indx,loss);
    % Check for target loss. If true, end the tracking

    if loss == 1
        res = [];
    else
        res = [y,x,y+H, x+W, loc(5)];
    end

end