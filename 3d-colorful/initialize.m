% function [U0,A0,xx0,yy0,xx,yy]=initialize(XY0,M,N,m0,lambda,z0,pix)
% ### input
% z0 : diffraction distance
% lambda: wavelength
% M,N: number of pixels in width and length on slm 
% m0: zoom factor
% pix: length of the pixel unit on slm
% XY0: complex amplituds on slm
% ## output
% xx0,yy0: pixel points on the diffraction plane 
% xx,yy: pixel points on the observation plane
% 
% 
% LM = M*pix; 
% LN = N*pix;
% n = 1:N;
% m = 1:M;
% dx0=pix;
% dy0=pix;
% dx=lambda*z0/(M*pix);
% dy=lambda*z0/(N*pix);
% 
% x0 = ((m-1)/m-0.5)*dx0;
% y0 = ((n-1)/n-0.5)*dy0;
% x = ((m-1)/m-0.5)*dx;
% y = ((n-1)/n-0.5)*dy;
% 
% 
% [xx0,yy0] = meshgrid(x0,y0);
% [xx,yy] = meshgrid(x,y);
function [U0,A0]=initialize(slices,N,M)
U0=cell(slices,1);
A0=cell(slices,1);
for i=1:slices
    A = imresize(imread(['../tmp/' num2str(i) '.jpg']),[N,M]);
    A=double(A)/255;
    phase=rand(N,M)*2*pi; %add random phase
    U0{i}=A.*exp(1i.*phase);  %inital complex amplitudes for later iterations
    A0{i}=abs(U0{i}); 
end

end