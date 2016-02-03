clear all; 

% img = imread('D:\Matlab\ucf11\ucf_11\Diving-Side\001\2538-5_70143.jpg');
% 
% % hog = vl_hog(img, 16);
% 
% img = img(1:end/2, 1:end/2, :);
% hog = CalcuHoG(img);
% % hsv = rgb2hsv(img);
% hsv = CalcuColorHist(img);
% hsv2 = CalcuColorHist2(img);
% % hue = CalcuColorHist(img);

% aa = load('d:\my_mat.mat');
% aa = aa.fea_init;
% bb = [];
% for idx = 1:max(size(aa))
%     if ~isempty(aa{idx})
%         bb = [bb; aa{idx}];
%     end    
% end
% 
% [class,type]=dbscan(bb,2);
% z = linkage(bb, 'single');
% co = inconsistent(z);
% t = cluster(z, 'cutoff', 1.15);

% for idx = 4:-1:4
%     a = 5
% end

f1 = fopen('d:\my_my.txt','a');
fprintf(f1, '\r\n');
fprintf(f1, 'I am !');

for idx = 1:2
    for jdx = 1:3
        fprintf(f1, '%4f ', jdx/5);        
    end
    
end
fprintf(f1, '%f', 4.5);
fclose(f1);

