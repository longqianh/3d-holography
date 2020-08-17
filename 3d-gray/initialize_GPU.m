function [U0,X0,xx0,yy0,xx,yy]=initialize_GPU(X0,M,N,m0,h,z0,pix)
pictures=size(X0,1);
U0=cell(pictures,1);

for i=1:pictures
    X1 = imresize(X0{i},[N,M]);
    X1 = imresize(X1,m0);
    [N1,M1] = size(X1);
    X = zeros(N,M);
    X(N/2-N1/2+1:N/2+N1/2, M/2-M1/2+1:M/2+M1/2) = X1(1:N1, 1:M1);
    Y=double(X);
    b=rand(N,M)*2*pi;
    
    U0{i}=gpuArray(Y.*exp(1i.*b));%add random phase and scale to [N,M],complex amplitude:U0
    X0{i}=gpuArray(abs(U0{i})); %picture initial amplitude:X0
    
end

LM = M*pix;
LN = N*pix;
L0=h*z0/pix;
n = 1:N;
m = 1:M;
x0=-L0/2+L0/M*(m-1);
y0=-L0/2+L0/N*(n-1);
[xx0,yy0] = meshgrid(x0,y0);
x = -LM/2+LM/M*(m-1);
y = -LN/2+LN/N*(n-1);
[xx,yy] = meshgrid(x,y);

xx0 = gpuArray(xx0);
yy0 = gpuArray(yy0);
xx = gpuArray(xx);
yy = gpuArray(yy);

end