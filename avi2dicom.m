function [ ] = avi2dicom( file_name, file_name_out )
%load the name of uint8 RGB (actuall gray) avifile, save the uint16 dicom file
%   Detailed explanation goes here

% v = VideoReader('ZeissFlow.avi')
v = VideoReader(file_name);
data_dicom = uint16(zeros(v.Height, v.Width, v.FrameRate*v.Duration));
frun = 0;
while hasFrame(v)
    frun = frun + 1;
    video = readFrame(v);
    data_dicom(:, :, frun) = uint16(video(:, :, 1)).*uint16(255);
end

data_output = permute(data_dicom, [1, 2, 4, 3]);
if nargin < 2
    file_name_out = [file_name(1: end-4) '.dcm'];
end
dicomwrite(data_output, file_name_out);

end