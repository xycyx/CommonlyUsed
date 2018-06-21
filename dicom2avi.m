function [] = dicom2avi(file_name,out_file_name)
%transfer uint8 or uint16 dicom to 0-255 avi
%   Detailed explanation goes here
% file_name = 'registered2.dcm';

img = dicomread(file_name);

% if it was uint16
if isa(img, 'uint16')
    img = img./256;
end
[depth,width, trans, frame_num] = size(img);

if nargin < 2
    out_file_name = [file_name(1: end-4) '.avi'];
end

v = VideoWriter(out_file_name,'Uncompressed AVI');
open(v);

for k = 1:frame_num 
   frame = uint8(img(:,:,1,k));
   writeVideo(v,frame);
end

close(v);
end

