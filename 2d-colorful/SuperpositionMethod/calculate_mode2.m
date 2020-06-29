
function [pic3,pic4] = calculate_mode2(XRGB,lambda,dist,rd_phase,shuangxiangwei)

XR = XRGB(:,:,1);
XG = XRGB(:,:,2);
XB = XRGB(:,:,3);
RGBmax = [max(max(XR)) max(max(XG)) max(max(XB))];

%--------------------------参数-----------------------------
if ~shuangxiangwei
    mode=1; %1球面随机相位，2球面双相位
else
    mode=2;
end
z0 = dist; 
hR = lambda{1}*1e-6 ; kR = 2*pi/hR;  
hG = lambda{2}*1e-6 ; kG = 2*pi/hG;  
hB = lambda{3}*1e-6 ; kB = 2*pi/hB; 
M = 1920;
N = 1080;         
pix= 0.008;      
%-----------------------------------------------------------
LM = M*pix;        %SLM长度(mm)
LN = N*pix;        %SLM宽度(mm)
s=0.8;             % s = input('图像的缩放比例(0->1): ');   % 用户需要的缩放比例
mMax = z0*hB/pix/LN;
%m = input(['像面扩展倍率m (最大值为 ',num2str(mMax),'): ']);
m=2;
L0 = LN * m;    % 像面宽度(mm)
zR1 = L0*pix/hR; zR2 = z0 - zR1;    % 红光sfft&dfft衍射距离
zG1 = L0*pix/hG; zG2 = z0 - zG1;    % 绿光sfft&dfft衍射距离
zB1 = L0*pix/hB; zB2 = z0 - zB1;    % 蓝光sfft&dfft衍射距离
f_rear = z0 * m/(m+1);  % 球面相位后焦距(mm)
f_front= z0 - f_rear;   % 球面相位前焦距(mm)

% 预处理(叠加球面相位)
n = 1:N;
m = 1:M;
x = -LM/2 + LM/M*(m-1);     % SLM宽度取样(mm)
y = -LN/2 + LN/N*(n-1);
[xx,yy] = meshgrid(x,y);
x0=-L0/2+L0/M*(m-1);        %像平面宽度取样
y0=-L0/2+L0/N*(n-1);   
[xx0,yy0] = meshgrid(x0,y0);
UR0 = Preprocess_z(XR,M,N,xx0,yy0,s,hR,f_rear,mode);
UG0 = Preprocess_z(XG,M,N,xx0,yy0,s,hG,f_rear,mode);
UB0 = Preprocess_z(XB,M,N,xx0,yy0,s,hB,f_rear,mode);
%---------------角谱衍射计算开始---------------%
URf = Diffr_smpscl(UR0,pix,M,N,LM,LN,L0,hR,kR,zR1,zR2);
UGf = Diffr_smpscl(UG0,pix,M,N,LM,LN,L0,hG,kG,zG1,zG2);
UBf = Diffr_smpscl(UB0,pix,M,N,LM,LN,L0,hB,kB,zB1,zB2);
%---------------角谱衍射计算结束---------------%

%-------------加载相息图的闪耀光栅------------------% 
uR0 = 0.5*(hG-hR)/hR/pix;     % 红光频谱点靠向绿光的频谱点
uG0 = 0;      % 绿光不动
uB0 = 0.5*(hG-hB)/hB/pix;     % 蓝光频谱点靠向绿光的频谱点
vR0 = 0.5*(hG-hR)/hR/pix - 10/f_front/pix;  % 红光倾斜照明正切值 10/f_front
vG0 = 0;                                    % 像移至x轴上
vB0 = 0.5*(hG-hB)/hB/pix + 10/f_front/pix;  % 蓝光倾斜照明正切值-10/f_front  
BlazR = 2*pi*uR0*xx + 2*pi*vR0*yy;  % 红光闪耀光栅
BlazG = 2*pi*uG0*xx + 2*pi*vG0*yy;  % 绿光闪耀光栅
BlazB = 2*pi*uB0*xx + 2*pi*vB0*yy;  % 蓝光闪耀光栅
URf2 = URf .* exp(1i*BlazR);
UGf2 = UGf .* exp(1i*BlazG);
UBf2 = UBf .* exp(1i*BlazB);
URGBf2 = URf2+UGf2+UBf2;
%-------------------------------------------------%
Utemp = URf2;
Phase{1} = angle(Utemp);
 if shuangxiangwei
 A = abs(Utemp); Amax = max(max(A));
 theta1 = Phase{1} + acos(A/Amax);
 theta2 = Phase{1} - acos(A/Amax);
 [M1,M2] = checkerboard(N,M);
 Phase{1}= mod(theta1.*M1 + theta2.*M2, 2*pi);
 end
Phase_slm{1}=Phase{1};
 
Utemp = UGf2;
Phase{2} = angle(Utemp);
 if shuangxiangwei
 A = abs(Utemp); Amax = max(max(A));
 theta1 = Phase{2} + acos(A/Amax);
 theta2 = Phase{2} - acos(A/Amax);
 [M1,M2] = checkerboard(N,M);
 Phase{2}= mod(theta1.*M1 + theta2.*M2, 2*pi);
 end
Phase_slm{2}=Phase{2};

Utemp = UBf2;
Phase{3} = angle(Utemp);
 if shuangxiangwei
 A = abs(Utemp); Amax = max(max(A));
 theta1 = Phase{3} + acos(A/Amax);
 theta2 = Phase{3} - acos(A/Amax);
 [M1,M2] = checkerboard(N,M);
 Phase{3}= mod(theta1.*M1 + theta2.*M2, 2*pi);
 end
Phase_slm{3}=Phase{3};

Utemp = URGBf2;
Phase{4} = angle(Utemp);
 if shuangxiangwei
 A = abs(Utemp); Amax = max(max(A));
 theta1 = Phase{4} + acos(A/Amax);
 theta2 = Phase{4} - acos(A/Amax);
 [M1,M2] = checkerboard(N,M);
 Phase{4}= mod(theta1.*M1 + theta2.*M2, 2*pi);
 end
Phase_slm{4}=Phase{4};
%-------------------相息图保存-----------------------%
Ih{1}=uint8(Phase_slm{1}/2/pi*255);%红
Ih{2}=uint8(Phase_slm{2}/2/pi*255);%绿
Ih{3}=uint8(Phase_slm{3}/2/pi*255);%蓝
Ih{4}=uint8(Phase_slm{4}/2/pi*255);%空间叠加
%----------------------------------------------------%
% figure;
% subplot(2,2,1),imshow(Ih{1});
% subplot(2,2,2),imshow(Ih{2});
% subplot(2,2,3),imshow(Ih{3});
% subplot(2,2,4),imshow(Ih{4});

%----------------加载模拟图闪耀光栅---------------------%

uR0 = -0.5/pix;     % 红光频谱点靠向绿光的频谱点
uG0 = -0.5/pix;     % 绿光不动
uB0 = -0.5/pix;     % 蓝光频谱点靠向绿光的频谱点
vR0 = -0.5/pix;     % 红光倾斜照明正切值 10/f_front
vG0 = -0.5/pix;     % 像移至x轴上
vB0 = -0.5/pix;     % 蓝光倾斜照明正切值-10/f_front
BlazR = 2*pi*uR0*xx + 2*pi*vR0*yy;  % 红光闪耀光栅
BlazG = 2*pi*uG0*xx + 2*pi*vG0*yy;  % 绿光闪耀光栅
BlazB = 2*pi*uB0*xx + 2*pi*vB0*yy;  % 蓝光闪耀光栅
URf = URf .* exp(1i*BlazR);
UGf = UGf .* exp(1i*BlazG);
UBf = UBf .* exp(1i*BlazB);

Utemp = URf;
Phase{1} = angle(Utemp);
 if shuangxiangwei
 A = abs(Utemp); Amax = max(max(A));
 theta1 = Phase{1} + acos(A/Amax);
 theta2 = Phase{1} - acos(A/Amax);
 [M1,M2] = checkerboard(N,M);
 Phase{1}= mod(theta1.*M1 + theta2.*M2, 2*pi);
 end
 
Utemp = UGf;
Phase{2} = angle(Utemp);
 if shuangxiangwei
 A = abs(Utemp); Amax = max(max(A));
 theta1 = Phase{2} + acos(A/Amax);
 theta2 = Phase{2} - acos(A/Amax);
 [M1,M2] = checkerboard(N,M);
 Phase{2}= mod(theta1.*M1 + theta2.*M2, 2*pi);
 end

Utemp = UBf;
Phase{3} = angle(Utemp);
 if shuangxiangwei
 A = abs(Utemp); Amax = max(max(A));
 theta1 = Phase{3} + acos(A/Amax);
 theta2 = Phase{3} - acos(A/Amax);
 [M1,M2] = checkerboard(N,M);
 Phase{3}= mod(theta1.*M1 + theta2.*M2, 2*pi);
 end
%----------sfft模拟还原----------%
  z = z0;
% while(z)   
UR0 = exp(1i*Phase{1});
UG0 = exp(1i*Phase{2});
UB0 = exp(1i*Phase{3});
URf = Diffr_sifft(UR0,M,N,pix,hR,kR,z);
UGf = Diffr_sifft(UG0,M,N,pix,hG,kG,z);
UBf = Diffr_sifft(UB0,M,N,pix,hB,kB,z);
URf=abs(URf);
UGf=abs(UGf);
UBf=abs(UBf);
URf=imresize(URf,[800,800]);
UGf=imresize(UGf,[800,800]);
UBf=imresize(UBf,[800,800]);

URf=imresize(URf,hR/hB);%扩大到800之内能对上
[~,tempm]=size(URf);
tempcut=(tempm-800)/2;
URf(:,tempm-tempcut:tempm)=[];
URf(tempm-tempcut:tempm,:)=[];
URf(:,1:tempcut)=[];
URf(1:tempcut,:)=[];

UGf=imresize(UGf,hG/hB);%扩大到800之内能对上
[~,tempm]=size(UGf);
tempcut=(tempm-800)/2;
UGf(:,tempm-tempcut:tempm)=[];
UGf(tempm-tempcut:tempm,:)=[];
UGf(:,1:tempcut)=[];
UGf(1:tempcut,:)=[];
URf=imresize(URf,[800,800]);URf=abs(URf);
UGf=imresize(UGf,[800,800]);UGf=abs(UGf);
UBf=imresize(UBf,[800,800]);UBf=abs(UBf);
dL=round(800*s*m*LN*pix/hB/z0);
Ur1=URf((401-dL):(401+dL),(401-dL):(401+dL));Ur1=Ur1/max(max(Ur1));
Ug1=UGf((401-dL):(401+dL),(401-dL):(401+dL));Ug1=Ug1/max(max(Ug1));
Ub1=UBf((401-dL):(401+dL),(401-dL):(401+dL));Ub1=Ub1/max(max(Ub1));
Uf=cat(3,Ur1,Ug1,Ub1);
Uffinale=imresize(Uf,[1000,1000]);
pic4=Uffinale;
%----------sfft模拟还原结束----------%

pic3=Ih{4};
% 存相息图
% [filename,folder] = uiputfile('*.bmp','储存相息图','lenna_DPH.bmp');
% imwrite(Ih{2},[folder,filename]);