function [] = PlotPiontCloud(img,orientation, depth_encode, markersize, show_mesh, save)
%PlotPiontCloud Plot the piont clound figure of input image
%   Input:
%         img: input 3D or 4D image matriax
%         orientation: the axis for MIP
%         depth_encode: the model of colormap
%         show_mesh: logical, plot the depth edcoded MIP and mesh image.
%         save: save the PLY file to current path
%   Example input: PlotPiontCloud(img,1, 2, 15, false, false)

% load the data
% img = dicomread('3D_face_final_1.dcm');

% get the maxinum position
img3d = squeeze(img);
[proj_img,ind ] = max(img3d,[], orientation);
ind_img = squeeze(ind);

% figure;
% subplot(121);
% imshow(squeeze(proj_img));
% subplot(122);
% imshow(ind_img,[]);

%% get the pointcloud map
img_length = size(ind_img, 1);
img_width = size(ind_img, 2);
img_depth = size(img3d, orientation);
count_point = img_length*img_width;
xyzPoints = zeros(count_point, 3);

% remove the zero value
ind_img(ind_img==1) = img_depth;

% get the pointcloud
% depth_encode = 0;
for x = 1: img_length
    for y = 1: img_width
        index = (x-1)*img_width + y;
        if depth_encode == 1
            xyzPoints(index,:) = [x, y, ind_img(x, y)];
        elseif depth_encode == 2
            xyzPoints(index,:) = [x, ind_img(x, y), y];
        elseif depth_encode == 3
            xyzPoints(index,:) = [ind_img(x, y), y, x];
        end
    end
end

% get the pointcloud (faster)

% generate teh pointcloud object
ptCloud = pointCloud(xyzPoints);

% % plot 3D image
% % ptCloud = pcread('teapot.ply');
% player = pcplayer(ptCloud.XLimits,ptCloud.YLimits,ptCloud.ZLimits);
% show(player)
% view(player,ptCloud);

% plot the 3D image
try
%     opengl hardware
    figure(111);
    pcshow(ptCloud, 'MarkerSize', markersize);
    colormap(gca, 'jet');
    colorbar()
catch ME
    disp('error occured')
end

% write it to the point cloud file
if save
    pcwrite(ptCloud,'faceOut','PLYFormat','binary');
end

if show_mesh
    % show 3D mesh
    figure(112);
    Show3Diso( img, 9 );
    
    % show color-coded projection image
    figure(113);
    colorMIP(permute(squeeze(img),[3,2,1]))
    colorbar();
end


end

