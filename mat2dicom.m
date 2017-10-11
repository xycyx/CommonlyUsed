function [ ] = mat2dicom( img, output)
%mat2dicom save 3D matrix to 4D dicom file (uint16)
%   Detailed explanation goes here
img = double(permute(img, [1 2 4 3]));
img_range = prctile(img(:), [0.01 99.9]);
img_write = uint16((img - img_range(1))*65535/(img_range(2)-img_range(1)));
dicomwrite(img_write, output);

end

