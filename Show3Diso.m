function [ ] = Show3Diso( D, thre )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

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
   'FaceColor',[1,.75,.65],...
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

