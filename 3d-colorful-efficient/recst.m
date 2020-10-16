function recst(tmp,L)
%  simulation of reconstruction
m0=0.5*L(3)./L;
% m0=[0.5 0.5 0.5];
res1=750*abs(tmp{1});
res2=1000*abs(tmp{2});
res3=1500*abs(tmp{3});
res1=imresize(res1,[1000 1000]);
res2=imresize(res2,[1000 1000]);
res3=imresize(res3,[1000 1000]);
res1=res1(500*(1-m0(1)):500*(1+m0(1)),500*(1-m0(1)):500*(1+m0(1)));
res2=res2(500*(1-m0(2)):500*(1+m0(2)),500*(1-m0(2)):500*(1+m0(2)));
res3=res3(500*(1-m0(3)):500*(1+m0(3)),500*(1-m0(3)):500*(1+m0(3)));
res1=imresize(res1,[1000 1000]);
res2=imresize(res2,[1000 1000]);
res3=imresize(res3,[1000 1000]);
figure(1),
subplot(1,3,1),imshow(res1);
subplot(1,3,2),imshow(res2);
subplot(1,3,3),imshow(res3);
figure(2),imshow(cat(3,res1,res2,res3));
end