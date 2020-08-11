function [pic3,pic4]=calculate_mode1(LambdaChoose,Lambda,XRGB,z0,f,random_phase,iter_num,spherical_phase,biphase)

channels=LambdaChoose{1}+LambdaChoose{2}+LambdaChoose{3};
pix= 0.008; 
M = 1920/channels;          
N = 1080; 
LM = M*pix;        
LN = N*pix;        

 
n = 1:N;
m = 1:M;
x = (m-1)/M*LM-LM/2;       % slm sampling (mm)
y = (n-1)/N*LN-LN/2;
[xx,yy] = meshgrid(x,y); 

blaze = 1;

m00=0.8;


X1 = imresize(XRGB,[N,M]); 
Xcolor = cell(3,1);
Xcolor{1} = X1(:,:,1);
Xcolor{2} = X1(:,:,2);
Xcolor{3} = X1(:,:,3);

% grayscale
if channels==1 
    X1gray = rgb2gray(X1);
    Xcolor{1}=X1gray;
    Xcolor{2}=X1gray;
    Xcolor{3}=X1gray;
end

which=1;
returnpic=cell(3,1);
for j=1:3 %for each channel
   if LambdaChoose{j}  
    lambda = Lambda{j}*1e-6;     
    L0 = lambda*z0/pix; %采样定理计算最大像平面大小
    % 修改补零：z0->z(i)
    
    x0 = (m-1)/M*L0-L0/2;   
    y0 = (n-1)/N*L0-L0/2;
    [xx0,yy0] = meshgrid(x0,y0); 
    
    %Lmax=min([L0,z2/f*LN]);
    Lmax=0.4*1e-3*z0/pix; % 目标像面的大小 ？
   
    % if use Biphase Encoding method
    if biphase 
        m00=0.5;
    end
    
    m0=m00*Lmax/L0;% 还想再小一点 
    
    % zooming and zero-padding
    Xcolor{j}=imresize(Xcolor{j},m0);
    [N1,M1] = size(Xcolor{j});
    Xtemp=zeros(N,M); 
    Xtemp(N/2-N1/2+1 : N/2+N1/2, M/2-M1/2+1 : M/2+M1/2)=Xcolor{j}(1:N1,1:M1);
    Xcolor{j}=Xtemp; 
    
    k = 2*pi/lambda;       
    U0=Xcolor{j};
    
    % random phase method
    if random_phase
        rd_phase=rand(N,M)*2*pi;
        U0=U0.*exp(1i.*rd_phase);
    end
  
    % Spherical Phase Encoding method
    if spherical_phase  
        z2 = z0-f;    % f : focal length
        sphr_phase = -pi*(xx0.^2 + yy0.^2)/(lambda*z2); 
        U0=U0.*exp(1i.*sphr_phase); 
    end
    A0= abs(U0);  %initial complex amplitudes for GS iteration
    
    
    for iter=1:iter_num+1
        Fresnel=exp(1i*k/2/z0*(xx0.^2+yy0.^2)); 
        f2=U0.*Fresnel; 
        Uf=fftshift(fft2(f2,N,M))*pix.^2; 
        phase=exp(1i*k*z0)/(1i*lambda*z0)*exp(1i*k/2/z0*(xx.^2+yy.^2)); 
        Uf=Uf.*phase; 
        Uffinale=Uf;
        Phase=angle(Uf)+pi;
        Ih=Phase;        
        %---iFFT----%
        U0=exp(1i*Phase-pi);
        Fresnel=exp(-1i*k/2/z0*(xx.^2+yy.^2));
        f2=U0.*Fresnel;
        Uf=ifft2(f2,N,M)/pix.^2;
        phase=exp(-1i*k*z0)/(-1i*lambda*z0)*exp(-1i*k/2/z0*(xx0.^2+yy0.^2));
        Uf=Uf.*phase;
        %------------%
        Phase=angle(Uf);
        U0=A0.*exp(1i*Phase);
    end
    %-----------%
    %双相位   
    if biphase
        Uf=Uffinale;
        Amplitude = abs(Uf); Amax = max(max(Amplitude)); 
        Phase = angle(Uf); 

        theta1 = Phase + acos(Amplitude/Amax); 
        theta2 = Phase - acos(Amplitude/Amax); 

        [board1,board2] = checkerboard(N,M); 
        DPH = theta1.^board1 + theta2.^board2; 
        Phase=mod(DPH+2*pi,2*pi);% Phase  0-2pi
        Ih=Phase;
    end
    %----SFFT----%
    U0=exp(1i*Ih);
    Fresnel=exp(-1i*k/2/z0*(xx.^2+yy.^2));
    f2=U0.*Fresnel;
    Uf=ifft2(f2,N,M)/pix.^2;
    phase=exp(-1i*k*z0)/(-1i*lambda*z0)*exp(-1i*k/2/z0*(xx0.^2+yy0.^2));
    Uf=Uf.*phase;
    %-----保存纯净还原图------%
    returnpic{j}(1:N1,1:M1)=Uf(N/2-N1/2+1:N/2+N1/2,M/2-M1/2+1:M/2+M1/2);
    returnpic{j}=abs(returnpic{j});
    returnpic{j}=returnpic{j}/max(max(returnpic{j}));
    returnpic{j} = imresize(returnpic{j},[1080,1920]);
    %------------------------%
    
    Phase=Ih;% Phase  0-2pi
      
    % 闪耀光栅 
    if blaze == 1   
    ktemp=0;
        if channels==1
            ktemp=(L0/2);
        end
        if channels==2
            if which==1
                ktemp= 1920/4*pix+(L0/2);
            else
                ktemp= -(1920/4*pix+(L0/2));
            end
        end
        if channels==3
            if which==1
                ktemp=1920/3*pix+L0/2;
            end
            if which==2
                ktemp=L0/2;
            end
            if which==3
                ktemp=-(1920/3*pix+L0/2);
            end
        end 
            u0 = ktemp/(lambda*z0);
            v0 = -((L0+Lmax+LN*1.5)/2)/(lambda*z0);
            Blazing = -2*pi*u0*xx - 2*pi*v0*yy; 
            Phase2 = mod(Phase+Blazing, 2*pi); 
            Phase=Phase2;% Phase 0-2pi
    end 
    
%    %---------------大图还原---------------%
%    
%         U0 = exp(1i*Phase-pi);  
%         Fresnel=exp(-1i*k/2/z0*(xx.^2+yy.^2));
%         f2=U0.*Fresnel;
%         Uf=ifft2(f2,N,M);
%         Uf=abs(Uf);
%         Uf=Uf./max(max(Uf));
%         Uf=imresize(Uf,[1000,1000]);
%         figure,imshow(Uf);
%    %---------------大图还原---------------% 
        
    phasepic{j}=uint8(Phase/2/pi*255);% 形成 0-255 灰度级的相息图 
    which=which+1;
   else
    phasepic{j}=zeros(N,M);
    returnpic{j}=zeros(1080,1920);
   end
end

if channels==3
pic3=[phasepic{1},phasepic{2},phasepic{3}];
end
if channels==2
    for i=1:3
        if ~LambdaChoose{i}
            if i==1
                pic3=[phasepic{2},phasepic{3}];
            end
            if i==2
                pic3=[phasepic{1},phasepic{3}];
            end
            if i==3
                pic3=[phasepic{1},phasepic{2}];
            end
        end
    end
end
if channels==1
    for i=1:3
        if LambdaChoose{i}
            pic3=phasepic{i};
        end
    end
end
pic4=cat(3,returnpic{1},returnpic{2},returnpic{3});
pic4=imresize(pic4,[1000,1000]);
%----------------------------------------calculatemode1--------------------------------------%
% filepath=pwd;           %保存当前工作目录
% cd('C:\');          %把当前工作目录切换到指定文件夹
% imwrite(picture3,'test_mode1.jpg');
% cd(filepath) ;           %切回原工作目录

%figure,imshow(picture3);
%figure,imshow(picture4);
end