function [pc_obj] = ProjPointCloud(proj_depth, proj_int, proj_c, layer_num, thre)
%ProjPointCloud Use the point cloud to visiualize the projection image
%   proj_depth: (M*N*layers) depth of MIP
%   proj_int: (M*N*layers)   intensity of MIP
%   proj_c: (M*N*RGB*layers) depth encoded color of each layer    
%   layer_num: current layer number
%   thre: the threshold to remove background noise

% adjust the image range
img_int = squeeze(proj_int(:, :, layer_num));
int_range = prctile(img_int(:), [20, 99.9]);
img_int = imadjust(img_int, int_range);

% get the mask by thresholding
% img_int = proj_int(:, :, layer_num);
mask_int = (img_int>thre);   % the intensity threshold

% get the size of image
[img_row, img_col, channel_num] = size(proj_depth);

% get the depth image
img_depth = proj_depth(:, :, layer_num).*double(mask_int);

% set the zero value as nan
img_depth(img_depth==0)=nan;
xyzPoints = zeros(img_row, img_col, 3);

% build the piontcloud image
for i = 1: img_row
    for j =1: img_col
        xyzPoints(i, j,:) = [i, j, img_depth(i, j)];
    end
end

% set the color by intensity and colormap
% img_color = ind2rgb(uint8(img_depth*127), cmap);
img_color = proj_c(:,:,:,layer_num).*img_int;

% recover the color range to [0 1]
int_range = prctile(img_color(:), [5, 98]);
img_color = imadjust(img_color, int_range);

pc_obj = pointCloud(xyzPoints, 'Intensity', img_int, 'Color', img_color);

% figure;
% pcshow(pc_obj);
% daspect([1 1 0.01])
% view(2)
end

