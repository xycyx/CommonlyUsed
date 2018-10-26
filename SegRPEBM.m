function [ RPE ] = SegRPEBM( video_path_read, result_save_path, save_video)
%SegRPEBM read the video, find the BM layer by maxinum intensity on the
%         moving averaging video, and refine the line by convex hull
%   input:
%       video_path_read: file path of the oct structural video
%       result_save_path: save the video and mat file to the path 
%       save_video:  boolean, ture to display and save the video(slow)
%   output: 
%       RPE: the location of segmentation line
% examble: RPE = SegRPEBM( 'F:\DoubleLayerProject\Drusen_cases\2057_OD\ZSubZeissStruct.avi', 'F:\DoubleLayerProject\Drusen_cases\2057_OD\', false);

% read the video to the memory
v = VideoReader(video_path_read);   %'F:\DoubleLayerProject\Drusen_cases\2057_OD\ZSubZeissStruct.avi'
info = get(v);
frame_num = int16(info.Duration*info.FrameRate);
img = zeros(info.Height, info.Width, frame_num);
i = 0;
while hasFrame(v)
    i = i + 1;
    vidFrame = readFrame(v);
    img(:, :, i) = vidFrame(:, :, 1);
end
%%
RPE_surface = zeros(info.Width, frame_num);  

% if save the video with line
if save_video
    video_save_path = fullfile(result_save_path, 'RPE_layer.avi');
    writerObj = VideoWriter(video_save_path);
    writerObj.FrameRate = 30;
    open(writerObj)
end 

% loop frames
for i = 1: frame_num
    % moving average
    if (i>1) && (i<frame_num)
        slice = mean(img(:, :, i-1: i+1), 3);
    else
        slice = img(:, :, i);
    end
    
    % get the maxinum location 
    [max_intensity, RPE] = max(slice, [], 1);
    
    % smooth 
    RPE_refine = medfilt1(RPE, 3);
    RPE_refine = imgaussfilt(RPE_refine, 2);
    
    % convex hull to fit the BM
    x = 1: info.Width;
    y = RPE_refine;
    k = convhull(x, y);
    
    % only select the bottom parts of the polygons 
    [max_x, max_ind] = max(x(k));    
    x_select = x(k(max_ind: end))';
    y_select = y(k(max_ind: end))';
    
    % interpolation 
    xq = 1: info.Width;
    vq = interp1(x_select, y_select, xq, 'pchip' ); %cubic 
    
    % save to the result
    RPE_surface(:, i) = vq;
    
    % if save the video with the lines
    if save_video
        figure(111);
        imshow(slice(1:800, :), []);
        hold on;
        plot (RPE_refine, '--', 'LineWidth',2);     % maxinum
        plot (x_select, y_select, '*', 'LineWidth',2);   %sample points
        plot(vq, 'LineWidth', 2)    % segmetnation line
        hold off;
        pause(0.01);
    
        frame = getframe(gcf);
        writeVideo(writerObj, frame);
    end
end

if save_video
    close(writerObj);
end

% figure;
% imshow(RPE_surface, [])

% smooth 
RPE = medfilt2(RPE_surface, [1, 4]);    % for motion 
RPE = imgaussfilt(RPE, 2);  % isotropy
% figure;
% imshow(RPE, [])

% save result
result_save_path = fullfile(result_save_path, 'RPE.mat');
save(result_save_path, 'RPE');

end

