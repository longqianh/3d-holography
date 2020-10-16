m=imread('./ironman.png');
A=abs(fft2(m));
% imshow(uint8(10000*ifft2(A))); % 幅度谱信息
phase=angle(fft2(m));
fig=uint8(100000*(abs(ifft2(phase))));
% imshow(fig); % 相位谱信息
imwrite(fig,'./test.png');
% phase=phase+rand(size(phase))*2*pi;

% imshow(uint8(100000*(abs(ifft2(phase)))));
m1=exp(1i*phase);
rm=ifft2(m1);
% imshow(uint8(rm));
