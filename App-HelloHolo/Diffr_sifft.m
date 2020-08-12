% ���� Diffr_inv(���䷴�ݼ���)
% ����: ����������ַ�������
function Uf = Diffr_sifft(U0,M,N,pix,h,k,z)

% ����ȡ��դ��
LM = M*pix;        % SLM����(mm)
LN = N*pix;        % SLM���(mm)
L0 = h*z/pix;      % ���ݲ����������Ĺ��ؽ���ƽ����(mm)
n = 1:N;
m = 1:M;
x0 = -L0/2 + L0/M*(m-1);    % ��ƽ����ȡ��
y0 = -L0/2 + L0/N*(n-1); 
[xx0,yy0] = meshgrid(x0,y0); 
x = -LM/2 + LM/M*(m-1);     % SLM���ȡ��(mm)
y = -LN/2 + LN/N*(n-1);   
[xx,yy] = meshgrid(x,y);

% sfft������ּ��� �Ƶ����ĵ�
f1 = U0.*exp(-1i*k/2/z*(xx.^2+yy.^2));
f2 = ifftshift(ifft2(f1,N,M));
Uf = f2.*exp(-1i*k*z)/(-1i*h*z).*exp(-1i*k/2/z*(xx0.^2+yy0.^2));

% % % sfft������ּ��� ��Ӧ��ʵԭλ�õ�
% % f1 = U0.*exp(-1i*k/2/z*(xx.^2+yy.^2));
% % f2 = ifft2(f1,N,M);
% % Uf = f2.*exp(-1i*k*z)/(-1i*h*z).*exp(-1i*k/2/z*(xx0.^2+yy0.^2));