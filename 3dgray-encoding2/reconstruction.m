function reconstruction(U,b,~)

% Reconstruction the image from complex amplitude U
% -- INPUT --
% U: complex amplitude of an 3-D object after Fresnel integration
% b: brightness
% -- OUTPUT --
% show and save the reconstructed image ( if receive 3 args ) 


res=b*abs(U/max(max(abs(U)))); 
res=imresize(res,[1000 1000]);
imshow(res);
if nargin == 3
     imwrite(res,'after-reconstruction.bmp');%../holo-graph/holo-graph
end
