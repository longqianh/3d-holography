function [U0,A0,xx0s,yy0s,xx,yy]=initialize(slices,M,N,m0,L,pix)

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
% L=lambda*z0/pix;


% from the observation plane do Fresnel diffraction integral to slm

x = ((m-1)/M-0.5)*LM;
y = ((n-1)/N-0.5)*LN;


[xx,yy] = meshgrid(x,y);

U0=cell(slices,1); % contain complex amplitudes of each piece
A0=cell(size(U0));

xx0s=cell(slices,1);
yy0s=cell(slices,1);
for i=1:slices
    x0 = ((m-1)/M-0.5)*L(i);
    y0 = ((n-1)/N-0.5)*L(i);
    [xx0,yy0] = meshgrid(x0,y0);
    xx0s{i}=xx0;
    yy0s{i}=yy0;
    img = imread(['../tmp/' num2str(i) '.jpg']);
    %  class(img)  % ans = 'uint8'
%     img = double(img); % important !
    
    img = imresize(img,[N,M]); %resize the piece 
    img = imresize(img,m0); % zooming

    [N1,M1] = size(img); % size of the piece after the adjustment
    X = zeros(N,M);
    X(N/2-N1/2+1 : N/2+N1/2, M/2-M1/2+1 : M/2+M1/2) = img; % piece with zero-paddings
    random_phase = rand(N,M)*2*pi; %add random phase
    U0{i}=double(X).*exp(1i.*random_phase); 
%     U0{i}=X; % for debug
    A0{i}=abs(U0{i});  %inital complex amplitudes for later iterations
    
end

end