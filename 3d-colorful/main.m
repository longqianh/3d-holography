% 3d colorful holography
% load data
modelpath='../datas/bunny.txt';
% modelpath='./1.txt';
model = load(modelpath);
[model,mcolor]=gray2color(model);

% mcolor=model(:,4:6);
% model=model(:,1:3);
% pcshow(model,mcolor);
iter_num=1;
M = 1920; N = 1080; % slm resolution: horizontal and vertical pixels
slices=10;
z0=700;
depth= 30;  % depth / mm
pix=0.008;  % unit pixel width / mm
iter_times=1;     % iteration times % NOTE it seems that no iteration would be better
z=(1:slices)/slices*depth+z0; % different diffraction distance because of the depth of the object

lambdas=[635e-6 520e-6 450e-6];
% L=lambdas*z0/pix;
L=cell(3,1);
for i=1:3
    L{i}=lambdas(i)*z/pix;
end

% dist/（lambda·z）
cut_pieces(model,mcolor,slices); 
[U0,xx0s,yy0s,xx,yy]=initialize(slices,M,N,L,pix); 

% GS iteration
pog=zeros(N,M);
rcst=cell(3,1);

for k = 1:3
    
    for iter=1:iter_times
        U_slm=zeros(N,M);

        for i=1:slices
             tmp=s_fft(U0{k,i},M,N,lambdas(k),z(i),xx0s{k,i},yy0s{k,i},xx,yy);
            U_slm=U_slm+tmp;% complex applitudes superposition 
        end
        
        phase=angle(U_slm)+pi;% takeout angle to get phase graph, angle is range from -pi to pi
        blaz=2*pi/(2*pix)*xx0s{k};
        blazdx=2*pi/(2*pix)*(L{2}-L{k})/L{k}*xx0s{k,i};
        blazdy=2*pi/(2*pix)*(L{2}-L{k})/L{k}*yy0s{k,i};
        phase=mod(phase+blaz+blazdx+blazdy,2*pi);
        
        for i=1:slices
            tmp=i_fft(exp(1i.*(phase-pi)),M,N,lambdas(k),z(i),xx0s{k,i},yy0s{k,i},xx,yy);
            if i==slices
                rcst{k}=tmp;
            end
            U0{k,i}=abs(U0{k,i}).*exp(1i*(angle(tmp))); 
        end
%         disp(iter*k/(iter_times*k));
    end
    
    pog(:,1+M*(k-1)/3:M*k/3)=phase(:,1+M*(k-1)/3:M*k/3);
    disp(k/3);
end
pog=uint8(pog/2/pi*255);
imwrite(pog,'main.bmp');%../holo-graph/holo-graph

% simulation of reconstruction
% recst(rcst,L);
