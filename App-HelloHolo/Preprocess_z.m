% 函数 Preprocess_z(可缩放彩色投影预处理)
% 功能: 将一幅任意形状 unsigned int 类型的图片,
%       补零至适合传感器尺寸, 并转换为浮点型,
%       添加汇聚的球面相位, 焦距为f,
%       对应光的波长为 h
% 注意: 只可用于正方形图像
function U = Preprocess_z(X0,M,N,xx,yy,s,h,f,mode)
b=rand(0,1);
% 图像采样率调整和补零
X1 = imresize(X0,[N*s M*s],'bicubic');
[N1,M1] = size(X1);
X = zeros(N,M); 
X(N/2-N1/2+1:N/2+N1/2,M/2-M1/2+1:M/2+M1/2)=X1(1:N1,1:M1);

% 转换类型，叠加球面相位
Y = double(X);
U=Y;
if mode==1
    b=rand(N,M)*1.5*pi;
    U = U.*exp(1j.*b);
    %disp('随机');
end
    p = -pi*(xx.^2 + yy.^2)/(h*f);   % 球面相位
    U = U.*exp(1j.*p);  % 图像叠加球面相位
    %disp('球面');


