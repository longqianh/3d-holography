function [U0,A0,xx0,yy0,xx,yy]=initialize(XY0,M,N,m0,lambda,z0,pix)

% Initialize plane points and get slices' amplitudes
% --------
% INPUT
% --------
% z0 : diffraction distance
% lambda: wavelength
% M,N: number of pixels in width and length on slm 
% m0: zooming scale
% pix: length of the pixel unit on slm
% XY0: complex amplituds on slm
% --------
% OUTPUT
% --------
% xx0,yy0: pixel points on the diffraction plane 
% xx,yy: pixel points on the observation plane


n = 1:N;
m = 1:M;
LM=pix*M;
LN=pix*N;
L=lambda*z0/pix;

% x0 = ((m-1)/M-0.5)*LM;
% y0 = ((n-1)/M-0.5)*LN;
% x = ((m-1)/M-0.5)*L;
% y = ((n-1)/N-0.5)*L;

% from the observation plane do Fresnel diffraction integral to slm
x0 = ((m-1)/M-0.5)*L;
y0 = ((n-1)/N-0.5)*L;
x = ((m-1)/M-0.5)*LM;
y = ((n-1)/M-0.5)*LN;

[xx0,yy0] = meshgrid(x0,y0);
[xx,yy] = meshgrid(x,y);

slices=size(XY0,1); % number of pieces
U0=cell(slices,1); % contain complex amplitudes of each piece
A0=cell(size(U0));
for i=1:slices
    XY1 = imresize(XY0{i},[N,M]); %resize the piece 
    XY1 = imresize(XY1,m0); % zoom
    [N1,M1] = size(XY1); % size of the piece after the adjustment
    X = zeros(N,M);
    X(N/2-N1/2+1:N/2+N1/2, M/2-M1/2+1:M/2+M1/2) = XY1; % piece with zero-paddings

    random_phase=rand(N,M)*2*pi; %add random phase
    U0{i}=X.*exp(1i.*random_phase); 
    A0{i}=abs(U0{i});  %inital complex amplitudes for later iterations
end

end