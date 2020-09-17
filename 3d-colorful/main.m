% 3d colorful holography
% load data
modelpath='../datas/bunny.txt';
model = load(modelpath);
[model,mcolor]=gray2color(model);
% pcshow(model,mcolor)
iter_num=1;
M = 1920; N = 1080; % slm resolution: horizontal and vertical pixels
slices=50;
z0=800;
depth= 30;  % depth / mm
pix=0.008;  % unit pixel width / mm
iter_times=1;     % iteration times % NOTE it seems that no iteration would be better
z=(1:slices)/slices*depth+z0; % different diffraction distance because of the depth of the object

lambdas=[635e-6 520e-6 450e-6];
L=lambdas*z0/pix;
% cut_pieces(model,mcolor,slices); 
[U0,xx0s,yy0s,xx,yy]=initialize(slices,M,N,L,pix); 

% GS iteration
pog=zeros(N,M);
for k = 1:3
    for iter=1:iter_times
        U_slm=zeros(N,M);

        for i=1:slices
            tmp=s_fft(U0{k,i},M,N,lambdas(k),z(i),xx0s{k},yy0s{k},xx,yy);
            U_slm=U_slm+tmp;% complex applitudes superposition 
        end
        
        phase=angle(U_slm)+pi;% takeout angle to get phase graph, angle is range from -pi to pi
%         phase=mod(phase-2*pi/lambdas(k)*L(k)/2,2*pi); %move the image right by L(k)/2

        
        for i=1:slices
            tmp=i_fft(exp(1i.*(phase-pi)),M,N,lambdas(k),z(i),xx0s{k},yy0s{k},xx,yy);
            U0{k,i}=abs(U0{k,i}).*exp(1i*(angle(tmp))); 
        end
        disp(iter/iter_times);
    end
    
    pog(:,1+M*(k-1)/3:M*k/3)=phase(:,1+M*(k-1)/3:M*k/3);
end
pog=uint8(pog/2/pi*255);
imwrite(pog,'main.bmp');%../holo-graph/holo-graph

% simulation of reconstruction
res=3000*abs(tmp);
res=imresize(res,[1000 1000]);
imshow(res);
