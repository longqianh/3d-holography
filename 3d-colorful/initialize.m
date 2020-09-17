function [U0,xx0s,yy0s,xx,yy]=initialize(slices,M,N,L,pix)

% Initialize plane points and get slices' amplitudes
% --------
% INPUT
% --------
% z0 : diffraction distance
% lambdas: three wavelengths
% M,N: number of pixels in width and length on slm 
% m0: zooming scale
% pix: length of the pixel unit on slm
% --------
% OUTPUT
% --------
% U0: complex amplitude in three channels
% xx0s,yy0s: pixel points on the diffraction plane in three channels
% xx,yy: pixel points on the observation plane


n = 1:N;
m = 1:M;
LM=pix*M;
LN=pix*N;
m0=0.5*L(1)./L; % zooming factor

% from the observation plane do Fresnel diffraction integral to slm
x = ((m-1)/M-0.5)*LM;
y = ((n-1)/N-0.5)*LN;
[xx,yy] = meshgrid(x,y);

U0=cell(3,slices,1); % contain complex amplitudes of each piece in three channels
xx0s=cell(3,1);
yy0s=cell(3,1);

for k=1:3
    x0 = ((m-1)/M-0.5)*L(k);
    y0 = ((n-1)/N-0.5)*L(k);
    [xx0,yy0] = meshgrid(x0,y0);
    xx0s{k}=xx0;
    yy0s{k}=yy0;
    
    for i=1:slices
        img = imread(['../tmp/' num2str(k) num2str(i) '.jpg']);
        img = imresize(img,[N,M]); %resize the piece 
        img = imresize(img,m0(k)); % zooming automatically
        [N1,M1] = size(img); % size of the piece after the adjustment
        X = zeros(N,M);
        X(N/2-N1/2+1 : N/2+N1/2, M/2-M1/2+1 : M/2+M1/2) = img; % piece with zero-paddings
        random_phase = rand(N,M)*2*pi; %add random phase
        U0{k,i}=double(X).*exp(1i.*random_phase); 
    end
end