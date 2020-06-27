function [picture6,picture5]=calculate_mode1(wavelength,lambda,XRGB,dist,f,random_phase,iters,spherical_phase,double_phase)
%----------------------------------------calculatemode1--------------------------------------%
blaze = 1;
m00=0.8;
%--------------参数传递-----------------%
z0 = dist;
z1 = f; % focal length
z2 = z0-z1;    
np=iters;
colors=wavelength{1}+wavelength{2}+wavelength{3};
%---------------------------------------%


pix= 0.008; 
M = 1920/colors;          
N = 1080; 
LM = M*pix;        
LN = N*pix;        
X1 = imresize(XRGB,[N,M]);
 
n = 1:N;
m = 1:M;
x = (m-1)/M*LM-LM/2;       % SLM 划分取样(mm) 
y = (n-1)/N*LN-LN/2;
[xx,yy] = meshgrid(x,y); 

Xcolor{1} = X1(:,:,1);
Xcolor{2} = X1(:,:,2);
Xcolor{3} = X1(:,:,3);
if colors==1
    Xcolor{1}=rgb2gray(X1);
    Xcolor{2}=rgb2gray(X1);
    Xcolor{3}=rgb2gray(X1);
end


%%%%%%%%--循环开始--%%%%%%%%%
which=1;
for j=1:3
   if wavelength{j}  %如果这个波长的启用了
    h = lambda{j}*1e-6;     
    L0 = h*z0/pix;%采样定理计算最大像平面大小
    
    x0 = (m-1)/M*L0-L0/2;    % 像平面宽度取样 
    y0 = (n-1)/N*L0-L0/2;
    [xx0,yy0] = meshgrid(x0,y0); 
    
    %Lmax=min([L0,z2/z1*LN]);
    Lmax=min([L0,0.4*1e-3*z0/pix]);
    if double_phase
        m00=0.5;
    end
    m0=m00*Lmax/L0;
    
    Xcolor{j}=imresize(Xcolor{j},m0);
    [N1,M1] = size(Xcolor{j});
    Xtemp=zeros(N,M);
    Xtemp(N/2-N1/2+1:N/2+N1/2,M/2-M1/2+1:M/2+M1/2)=Xcolor{j}(1:N1,1:M1);
    Xcolor{j}=Xtemp;
    
    k = 2*pi/h;       
    U0=Xcolor{j};
    U0=double(U0);
    
    
    if random_phase
    b1=rand(N,M)*2*pi;
    U0=U0.*exp(1i.*b1);
    end
    if spherical_phase  
    b = -pi*(xx0.^2 + yy0.^2)/(h*z2); 
    U0=U0.*exp(1i.*b); 
    end
    X0= abs(U0);  %初始场振幅，迭代用
    
    
    for p=1:np+1
        Fresnel=exp(1i*k/2/z0*(xx0.^2+yy0.^2)); 
        f2=U0.*Fresnel; 
        Uf=fftshift(fft2(f2,N,M))*pix.^2; 
        phase=exp(1i*k*z0)/(1i*h*z0)*exp(1i*k/2/z0*(xx.^2+yy.^2)); 
        Uf=Uf.*phase; 
        Uffinale=Uf;
        Phase=angle(Uf)+pi;
        Ih=Phase;        
        %----SFFT----%
        U0=exp(1i*Phase-pi);
        Fresnel=exp(-1i*k/2/z0*(xx.^2+yy.^2));
        f2=U0.*Fresnel;
        Uf=ifft2(f2,N,M)/pix.^2;
        phase=exp(-1i*k*z0)/(-1i*h*z0)*exp(-1i*k/2/z0*(xx0.^2+yy0.^2));
        Uf=Uf.*phase;
        %------------%
        Phase=angle(Uf);
        U0=X0.*exp(1i*Phase);
    end
    %-----------%
    %双相位   
        if double_phase
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
        phase=exp(-1i*k*z0)/(-1i*h*z0)*exp(-1i*k/2/z0*(xx0.^2+yy0.^2));
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
        if colors==1
            ktemp=(L0/2);
        end
        if colors==2
            if which==1
                ktemp= 1920/4*pix+(L0/2);
            else
                ktemp= -(1920/4*pix+(L0/2));
            end
        end
        if colors==3
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
            u0 = ktemp/(h*z0);
            v0 = -((L0+Lmax+LN*1.5)/2)/(h*z0);
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

if colors==3
picture6=[phasepic{1},phasepic{2},phasepic{3}];
end
if colors==2
    for i=1:3
        if ~wavelength{i}
            if i==1
                picture6=[phasepic{2},phasepic{3}];
            end
            if i==2
                picture6=[phasepic{1},phasepic{3}];
            end
            if i==3
                picture6=[phasepic{1},phasepic{2}];
            end
        end
    end
end
if colors==1
    for i=1:3
        if wavelength{i}
            picture6=phasepic{i};
        end
    end
end
picture5=cat(3,returnpic{1},returnpic{2},returnpic{3});
picture5=imresize(picture5,[1000,1000]);
%----------------------------------------calculatemode1--------------------------------------%
% filepath=pwd;           %保存当前工作目录
% cd('C:\');          %把当前工作目录切换到指定文件夹
% imwrite(picture3,'test_mode1.jpg');
% cd(filepath) ;           %切回原工作目录

%figure,imshow(picture3);
%figure,imshow(picture4);
end