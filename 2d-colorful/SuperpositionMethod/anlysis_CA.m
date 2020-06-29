
 function CA = anlysis_CA(X0,Uf)
 X0=uint8(X0);
 X0=imresize(X0,[1000,1000]);
 Uf=255.*Uf;
 Uf=uint8(Uf);
 %figure,imshow(X0),figure,imshow(Uf);
 CA_R=X0(:,:,1)-Uf(:,:,1);
 CA_G=X0(:,:,2)-Uf(:,:,2);
 CA_B=X0(:,:,3)-Uf(:,:,3);
 CA=cat(3,abs(CA_R),abs(CA_G),abs(CA_B));

 CA_1=mean(mean(X0(:,:,1)))-mean(mean(Uf(:,:,1)));
 CA_2=mean(mean(X0(:,:,2)))-mean(mean(Uf(:,:,2)));
 CA_3=mean(mean(X0(:,:,3)))-mean(mean(Uf(:,:,3)));
 
 
 figure,imshow(CA);
 xlabel([' ',' RGB色差 = ',num2str(-CA_1),'    ',num2str(-CA_2),'    ',num2str(-CA_3),'  灰度值']); title('色差分析'); 
 end