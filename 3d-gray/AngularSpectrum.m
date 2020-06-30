function U = AngularSpectrum(U0,pix,M,N,lambda,z0)
k=2*pi/lambda;
LM=M*pix;
LN=N*pix;
L=lambda*z0/pix;
n = 1:N;
m = 1:M;
u=((m-1)/M-0.5)*L;
v=((n-1)/N-0.5)*L;
% u = -M/L/2+1/L*(m-1);
% v = -N/L/2+1/L*(n-1);
[uu,vv] = meshgrid(u,v); % 物平面频域采样
H = exp(1i*k*z0*sqrt(1-(lambda*uu).^2-(lambda*vv).^2));   % 传递函数
U = fft2(U0.*H,N,M);

