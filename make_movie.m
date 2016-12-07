% read all images in current folder and output the avi video

imageNames = dir(fullfile('*.png'));
imageNames = {imageNames.name}';

outputVideo = VideoWriter(fullfile('flux_in.avi'));
outputVideo.FrameRate = 4;
open(outputVideo)

for ii = 1:length(imageNames)
   img = imread(fullfile(imageNames{ii}));
   writeVideo(outputVideo,img(923:5555,900:4666,:))
end

close(outputVideo)