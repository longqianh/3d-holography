lambda=640e-6;
M=1920;N=1080;
z0=800;
pix=0.008;
path='/Users/huanglongqian/Documents/ZJU/科研/3D彩虹全息/3180105524 黄隆钤/实验数据/实验相息图/3Dgray/bunny.bmp';

n = 1:N;
m = 1:M;
LM=pix*M;
LN=pix*N;
L=lambda*z0/pix;

x0 = ((m-1)/m-0.5)*LM;
y0 = ((n-1)/n-0.5)*LN;
x = ((m-1)/m-0.5)*L;
y = ((n-1)/n-0.5)*L;

[xx0,yy0] = meshgrid(x0,y0);
[xx,yy] = meshgrid(x,y);
bunny=imread(path);
bunny=bunny(:,:,1);
phase=double(bunny)*2*pi/255;
U=s_fft(exp(1i.*phase),M,N,lambda,z0,xx0,yy0,xx,yy);
% U=i_fft(exp(1i.*phase),M,N,lambda,z0,xx0,yy0,xx,yy);
% U=AngularSpectrum(exp(1i.*phase),pix,M,N,lambda,z0);
A=abs(U);
A=uint8(A/max(max(A))*255);
A=imresize(A,[1000 1000]);
imshow(A)

