% 函数 Diffr_inv(衍射反演计算)
% 功能: 角谱衍射积分法逆运算
function Uf = Diffr_sifft(U0,M,N,pix,h,k,z)

% 生成取样栅格
LM = M*pix;        % SLM长度(mm)
LN = N*pix;        % SLM宽度(mm)
L0 = h*z/pix;      % 根据采样定理计算的光重建像平面宽度(mm)
n = 1:N;
m = 1:M;
x0 = -L0/2 + L0/M*(m-1);    % 像平面宽度取样
y0 = -L0/2 + L0/N*(n-1); 
[xx0,yy0] = meshgrid(x0,y0); 
x = -LM/2 + LM/M*(m-1);     % SLM宽度取样(mm)
y = -LN/2 + LN/N*(n-1);   
[xx,yy] = meshgrid(x,y);

% sfft衍射积分计算 移到中心的
f1 = U0.*exp(-1i*k/2/z*(xx.^2+yy.^2));
f2 = ifftshift(ifft2(f1,N,M));
Uf = f2.*exp(-1i*k*z)/(-1i*h*z).*exp(-1i*k/2/z*(xx0.^2+yy0.^2));

% % % sfft衍射积分计算 对应真实原位置的
% % f1 = U0.*exp(-1i*k/2/z*(xx.^2+yy.^2));
% % f2 = ifft2(f1,N,M);
% % Uf = f2.*exp(-1i*k*z)/(-1i*h*z).*exp(-1i*k/2/z*(xx0.^2+yy0.^2));