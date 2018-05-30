
%% call the ProjPointClound funtion of 3 layers
% build the pointcloud
thre = 0.2;
pc_obj1 = ProjPointCloud(proj_depth, proj_int, proj_c, 1, thre);
pc_obj2 = ProjPointCloud(proj_depth, proj_int, proj_c, 2, thre);
pc_obj3 = ProjPointCloud(proj_depth, proj_int, proj_c, 3, thre);

% merage 
ptCloudOut = pcmerge(pc_obj1, pc_obj2, 1);
ptCloudOut = pcmerge(ptCloudOut, pc_obj3, 1);

% denoise, can be removed  
ptCloudOut = pcdenoise(ptCloudOut, 'Threshold',3);

% rearrange z scale
ptlocation = ptCloudOut.Location;
ptlocation(:,3) = ptlocation(:, 3)*180.0;
ptCloudOut_scale = pointCloud(ptlocation, 'Color', ptCloudOut.Color);
pcwrite(ptCloudOut_scale, 'pcstack.ply');

%% display
h0 = figure;
set(gcf, 'Position', [100, 100, 800, 800])
h0.Color = 'black';
h = pcshow(ptCloudOut, 'MarkerSize',10);
h.Color= 'black';
daspect([1 1 0.005])

% make the animation
f(960) = struct('cdata',[],'colormap',[]);  % store the video
camzoom(1.1) % set the camera zoom factor to avoid zoom change
view(0, -90);

% orbit camera
ind = 0;
for j=1:8
    for i=1:40
        inc = (cos(2*pi/40*ind)-1)*0.5;
        camorbit(0,inc,'camera');
        pause(0.01);
        f(ind) = getframe(gcf);
        ind = ind + 1;
        drawnow;
    end
    for i=1:40
        inc = (-cos(2*pi/40*ind)+1)*0.25;
        camorbit(0,inc,'camera');
        pause(0.01);
        f(ind) = getframe(gcf);
        ind = ind + 1;
        drawnow;
    end
    inc_ind = 0;
    for i=1:40
        inc = (cos(2*pi/40*ind)-1)*0.5;
        camorbit(inc,0,'data',[0 0 1]);
        f(ind) = getframe(gcf);
        ind = ind + 1;
        pause(0.01);
        drawnow;
    end
end

% % not smooth version
% ind = 1;
% for j=1:8
%     for i=1:40
%         camorbit(0,-0.5,'camera');
%         pause(0.01);
%         f(ind) = getframe(gcf);
%         ind = ind + 1;
%         drawnow;
%     end
%     for i=1:40
%         camorbit(0,0.25,'camera');
%         f(ind) = getframe(gcf);
%         ind = ind + 1;
%         drawnow;
%     end
%     for i=1:40
%         camorbit(0.5,0,'data',[0 0 1]);
%         f(ind) = getframe(gcf);
%         ind = ind + 1;
%         pause(0.01);
%         drawnow;
%     end
% end

%% save the video
% movie(fig, f, 1);   %play the movie

video_obj = VideoWriter('motion_smooth.avi','Motion JPEG AVI');
video_obj.Quality = 95;
video_obj.FrameRate = 40;
% video_obj.CompressionRatio = 5;
open(video_obj);
for i=1:length(f)
    i;
    writeVideo(video_obj, f(i).cdata);
end
close(video_obj);




