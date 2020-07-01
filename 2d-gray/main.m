M=1920;N=1080;
lambda=532e-6; % wavelength of the light , 532nm = 532e-6 mm for green light
z0 = 800;  %distance between the defracted plane and observation screen / mm
pix=0.008;  % unit pixel width / mm
LM = M*pix;
LN = N*pix;
L0=lambda*z0/pix;
n = 1:N;
m = 1:M;
x0 = -L0/2+L0/M*(m-1); %像平面宽度取样 ？
y0 = -L0/2+L0/N*(n-1);
[xx0,yy0] = meshgrid(x0,y0);
x = -LM/2+LM/M*(m-1); %SLM宽度取样/mm ？
y = -LN/2+LN/N*(n-1);
[xx,yy] = meshgrid(x,y);

% M=1000;N=1000;
I=imread('../datas/est.png');
I=imresize(I,[N,M]);
I=double(I);
I=I./max(max(I));
avg1=mean(mean(I));
figure;
axis([0 iter_num 0 1]);
xlabel('iterations');,
ylabel('RMSE');
hold on;
I1=I;

for n=1:100
    H=fftshift(i_fft(I1,M,N,lambda,z0,xx0,yy0,xx,yy));
    I2=s_fft(fftshift(exp(1i.*angle(H))),M,N,lambda,z0,xx0,yy0,xx,yy);
    avg2=mean(mean(abs(I2)));
    I2=(I2./avg2).*avg1; %保持相位不变 使振幅接近一致
    rmse=mean(mean((abs(I2)-I).^2))^0.5;
    plot(n,rmse,'o');
    pause(0.3);
    I1=I.*exp(1i*angle(I2));
end

hold off;

phase=angle(H)+pi;
imshow(uint8(phase/2/pi*255));
% I2=I2./max(max(abs(I2)));
% figure;imshow(mat2gray(abs(I2)));






%% spectrum relation
% imshow(mat2gray(I))
PH=rand(N,M);
I=I.*exp(2i*pi*PH);

% encoding
FTS=fftshift(ifft2(fftshift(I)));
% FTS=ifft2(I);
A=abs(FTS); % spectrum modulus
P=angle(FTS); % spectrum phase
% figure;imshow(mat2gray(A));
% figure;imshow(mat2gray(P));
imshow(mat2gray(abs(fftshift(fft2(A.*exp(1i*P))))));

% reconstruction
% R=fftshift(ifft2(fftshift(exp(-1i.*P))));
% imshow(mat2gray(abs(R)));





