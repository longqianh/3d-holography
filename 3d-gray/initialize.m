function [U0,XY0,xx0,yy0,xx,yy]=initialize(XY0,M,N,m0,lambda,z0,pix)
pictures=size(XY0,1); % number of pieces
U0=cell(pictures,1); % contain complex amplitudes of each piece

for i=1:pictures
    XY1 = imresize(XY0{i},[N,M]); %resize the piece 
    XY1 = imresize(XY1,m0); % zoom
    [N1,M1] = size(XY1); % size of the piece after the adjustment
    X = zeros(N,M);
    X(N/2-N1/2+1:N/2+N1/2, M/2-M1/2+1:M/2+M1/2) = XY1; % piece with zero-paddings
 
    random_phase=rand(N,M)*2*pi; %add random phase
    U0{i}=X.*exp(1i.*random_phase); 
    XY0{i}=abs(U0{i});  %inital complex amplitudes for later iterations
end
LM = M*pix;
LN = N*pix;
L0=lambda*z0/pix;
n = 1:N;
m = 1:M;
x0 = -L0/2+L0/M*(m-1); 
y0 = -L0/2+L0/N*(n-1);
[xx0,yy0] = meshgrid(x0,y0);
x = -LM/2+LM/M*(m-1); 
y = -LN/2+LN/N*(n-1);
[xx,yy] = meshgrid(x,y);
end