
%信噪比
 function SNR = anlysis_SNR(X0,Uf)
X0=uint8(X0);
X0=imresize(X0,[1000,1000]);
Uf=255.*Uf;
Uf=uint8(Uf);
Y{1}=X0(:,:,1);Y{2}=X0(:,:,2);Y{3}=X0(:,:,3);

Y_rec1 = abs(256/max(max(abs(Uf(:,:,1))))*Uf(:,:,1)); 
Y_rec2 = abs(256/max(max(abs(Uf(:,:,2))))*Uf(:,:,2)); 
Y_rec3 = abs(256/max(max(abs(Uf(:,:,3))))*Uf(:,:,3)); 
SNR1 = 10*(log(sum(sum(Y_rec1.^2))) - log(sum(sum((Y{1}-Y_rec1).^2))))/log(10);
SNR2 = 10*(log(sum(sum(Y_rec2.^2))) - log(sum(sum((Y{2}-Y_rec2).^2))))/log(10);
SNR3 = 10*(log(sum(sum(Y_rec3.^2))) - log(sum(sum((Y{3}-Y_rec3).^2))))/log(10);

figure,imshow(abs(Uf-X0)); 
xlabel([' ',' RGB信噪比 = ',num2str(SNR1),'   ',num2str(SNR2),'   ',num2str(SNR3),'  dB']); title('噪声分析'); 
 end
