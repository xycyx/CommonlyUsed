function [ ] = Show3Diso( D, thre )
%Show3Diso shows 3D visiualized mesh image by scalar 3D image
%   D: input images
%   thre: threshold 

D = squeeze(D);
% D = flip(D(10:end,:,:), 1);
D(D<thre) = 0;
% imshow(D(:,:,1))
% load mri
% D = squeeze(D);
figure;
% colormap(map)
Ds = smooth3(D);
hiso = patch(isosurface(Ds, 5),...
   'FaceColor',[252./255, 157./255, 154./255],...%[1,.75,.65],...
   'EdgeColor','none');
isonormals(Ds,hiso)

% hcap = patch(isocaps(D,5),...
%    'FaceColor','interp',...
%    'EdgeColor','none');

view(35,30) 
axis tight 
% daspect([1,1,.4])
daspect([1, 1.5, 1 ])

lightangle(45,0);
lighting gouraud
% hcap.AmbientStrength = 0.6;
hiso.SpecularColorReflectance = 0;
hiso.SpecularExponent = 50;

end

