% ------------------------------------------------------------------------
function boxes = calc_proposals(boxes, imgsize, flip_index)
% ------------------------------------------------------------------------
if flip_index == 1
    % do nothing
elseif flip_index == 2
    % flipud
    boxes(:, [2, 4]) = imgsize(2) + 1 - boxes(:, [4, 2]);
elseif flip_index == 3
    boxes = boxes(:, [2, 1, 4, 3]);
elseif flip_index == 4
    % rot90
    boxes = cat(2, boxes(:, 2), imgsize(1) + 1 - boxes(:, 3), boxes(:, 4), imgsize(1) + 1 - boxes(:, 1));
elseif flip_index == 5
    % fliplr
    boxes(:, [1, 3]) = imgsize(1) + 1 - boxes(:, [3, 1]);
elseif flip_index == 6
    %
    boxes = cat(2, imgsize(1) + 1 - boxes(:, 3), imgsize(2) + 1 - boxes(:, 4), imgsize(1) + 1 - boxes(:, 1),  imgsize(2) + 1 - boxes(:, 2));
elseif flip_index == 7
    %
    boxes = cat(2, imgsize(2) + 1 - boxes(:, 4), boxes(:, 1), imgsize(2) + 1 - boxes(:, 2), boxes(:, 3));
elseif flip_index == 8
    %
    boxes = cat(2, imgsize(2) + 1 - boxes(:, 4), imgsize(1) + 1 - boxes(:, 3), imgsize(2) + 1 - boxes(:, 2),  imgsize(1) + 1 - boxes(:, 1));
end