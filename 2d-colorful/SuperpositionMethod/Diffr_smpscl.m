% 函数 Diffr_smpscl(可缩放彩色投影衍射计算)
% 功能: 利用 角谱衍射法 + s-fft 计算变采样率衍射积分
function U2 = Diffr_smpscl(U0,pix,M,N,LM,LN,L0,h,k,z1,z2)
n = 1:N;
m = 1:M;

% Step1: 角谱衍射计算
u = -M/L0/2+1/L0*(m-1);
v = -N/L0/2+1/L0*(n-1);
[uu,vv] = meshgrid(u,v); % 物平面频域采样
H = exp(1j*k*z2*sqrt(1-(h*uu).^2-(h*vv).^2));   % 传递函数
Fourier1 = fftshift(fft2(U0,N,M));    % 物光场频谱
Fourier2 = Fourier1.*H;  % 中间平面光场频谱
U1 = ifft2(Fourier2,N,M);% 中间平面光场

% Step2: sfft衍射计算
x0=-L0/2+L0/M*(m-1);
y0=-L0/2+L0/N*(n-1);
[xx0,yy0] = meshgrid(x0,y0);% 中间平面空域取样
x = -LM/2+LM/M*(m-1);   
y = -LN/2+LN/N*(n-1);  
[xx,yy] = meshgrid(x,y);    % SLM平面空域采样
Fourier1 = U1.*exp(1j*k/2/z1*(xx0.^2+yy0.^2));
Fourier2 = fft2(Fourier1,N,M) * pix.^2;
U2 = Fourier2.*(exp(1j*k*z1)/(1j*h*z1)*exp(1j*k/2/z1*(xx.^2+yy.^2)));