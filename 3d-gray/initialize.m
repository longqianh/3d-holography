function [U0,A0,xx0,yy0,xx,yy]=initialize(XY0,M,N,m0,lambda,z0,pix)
pictures=size(XY0,1); % number of pieces
U0=cell(pictures,1); % contain complex amplitudes of each piece
A0=cell(size(U0));
for i=1:pictures
    XY1 = imresize(XY0{i},[N,M]); %resize the piece 
    XY1 = imresize(XY1,m0); % zoom
    [N1,M1] = size(XY1); % size of the piece after the adjustment
    X = zeros(N,M);
    X(N/2-N1/2+1:N/2+N1/2, M/2-M1/2+1:M/2+M1/2) = XY1; % piece with zero-paddings
 
    random_phase=rand(N,M)*2*pi; %add random phase
    U0{i}=X.*exp(1i.*random_phase); 
    A0{i}=abs(U0{i});  %inital complex amplitudes for later iterations
end

LM = M*pix;
LN = N*pix;
L0=lambda*z0/pix;
n = 1:N;
m = 1:M;
% make x0,y0 centrosymmetric
x0 = (m-1)/M*L0-L0/2; 
y0 = (n-1)/N*L0-L0/2;
x = (m-1)/M*LM-LM/2; 
y = (n-1)/N*LN-LN/2;
[xx0,yy0] = meshgrid(x0,y0);
[xx,yy] = meshgrid(x,y);
end