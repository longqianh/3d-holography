function img = reconstruction(U,b)

% Reconstruction the image from complex amplitude U
% -- INPUT --
% U: complex amplitude of an 3-D object after Fresnel integration
% b: brightness
% -- OUTPUT --
% show and save the reconstructed image ( if receive 3 args ) 


img=b*abs(U/max(max(abs(U)))); 
img=imresize(img,[1000 1000]);
img=cat(3,img,img,img);
% imshow(img);
% if nargin == 3
%      imwrite(img,'after-reconstruction.bmp');%../holo-graph/holo-graph
% end
