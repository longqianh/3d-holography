% 3d colorful holography
% load data
modelroot='../datas/common_3d_models/';
modelname='bunny';
model = load([modelroot,modelname,'.txt']);
[model,mcolor]=gray2color(model);
% mcolor=model(:,4:6);
% model=model(:,1:3);
pcshow(model,mcolor);
iter_num=1;
M = 1920/3; N = 1080; % slm resolution: horizontal and vertical pixels
slices=50;
z0=800;
depth= 30;  % depth / mm
pix=0.008;  % unit pixel width / mm
z=(1:slices)/slices*depth+z0; % different diffraction distance because of the depth of the object

lambdas=[635e-6 520e-6 450e-6];
% L=lambdas*z0/pix;
L=cell(3,1);
for i=1:3
    L{i}=lambdas(i)*z/pix;
end

% dist/（lambda·z）
cutted_pieces=cut_pieces(model,mcolor,slices); 
[U0,xx0s,yy0s,xx,yy]=initialize(cutted_pieces,M,N,L,pix,z); 

% GS iteration
pog=zeros(N,M*3);
rcst=cell(3,1);

planex=-M/2:M/2-1;
planey=-N/2:N/2-1;

for k = 1:3
    
        U_slm=zeros(N,M);
        lambda=lambdas(k);
        parfor i=1:slices
             U_slm=U_slm+s_fft(U0{k,i},M,N,lambda,z(i),xx0s{k,i},yy0s{k,i},xx,yy);
        end

        phase=angle(U_slm);
        phase=mod(phase+planey'.*pi+planex.*pi,2*pi);
    
    pog(:,1+M*(k-1):M*k)=phase; % (1+(M*3)*(k-1)/3:(M*3)*k/3)
end
pog=uint8(pog/2/pi*255);
imwrite(pog,[modelname,'.bmp']);

clear fig;
% simulation of reconstruction
% recst(rcst,L);

% 划分法：1/3并 后者 从1切
