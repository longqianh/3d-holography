% ���� Diffr_smpscl(�����Ų�ɫͶӰ�������)
% ����: ���� �������䷨ + s-fft �����������������
function U2 = Diffr_smpscl(U0,pix,M,N,LM,LN,L0,h,k,z1,z2)
n = 1:N;
m = 1:M;

% Step1: �����������
u = -M/L0/2+1/L0*(m-1);
v = -N/L0/2+1/L0*(n-1);
[uu,vv] = meshgrid(u,v); % ��ƽ��Ƶ�����
H = exp(1j*k*z2*sqrt(1-(h*uu).^2-(h*vv).^2));   % ���ݺ���
Fourier1 = fftshift(fft2(U0,N,M));    % ��ⳡƵ��
Fourier2 = Fourier1.*H;  % �м�ƽ��ⳡƵ��
U1 = ifft2(Fourier2,N,M);% �м�ƽ��ⳡ

% Step2: sfft�������
x0=-L0/2+L0/M*(m-1);
y0=-L0/2+L0/N*(n-1);
[xx0,yy0] = meshgrid(x0,y0);% �м�ƽ�����ȡ��
x = -LM/2+LM/M*(m-1);   
y = -LN/2+LN/N*(n-1);  
[xx,yy] = meshgrid(x,y);    % SLMƽ��������
Fourier1 = U1.*exp(1j*k/2/z1*(xx0.^2+yy0.^2));
Fourier2 = fft2(Fourier1,N,M) * pix.^2;
U2 = Fourier2.*(exp(1j*k*z1)/(1j*h*z1)*exp(1j*k/2/z1*(xx.^2+yy.^2)));