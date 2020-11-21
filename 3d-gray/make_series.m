clear;clc;clf;
%  parameters
M = 1920; N = 1080; % slm resolution: horizontal and vertical pixels
slices=50; % number of slices
m0 = 0.8 ;  % image zoom factor: to prevent image superposition
lambda=532e-6; % wavelength of the light , 532nm = 532e-6 mm for green light
z0 = 500;  %distance between the defracted plane and observation screen / mm

depth= 30;  % depth / mm
pix=0.008;  % unit pixel width / mm
iter_times=1;     % iteration times % NOTE it seems that no iteration would be better
z=(1:slices)/slices*depth+z0; % different diffraction distance because of the depth of the object
L=lambda.*z/pix; % 观察面总长
%  load data
% prefix='sur_4_rot_';
prefix='sur_1_rot_reverse_';
parfor img_idx=1:15
    filename=['../datas/cube_surface4/',prefix,num2str((img_idx)*6),'.txt'];
    model = load(filename);
    rotm(model,60,60,60);

    %  cut pieces and get the slices
    cutted_pieces=cut_pieces(model,slices); 

    %  resize the slices and add random phase on each slice
    [U0,A0,xx0s,yy0s,xx,yy]=initialize(cutted_pieces,M,N,m0,L,pix); 

% tmp=cell(slices,1); % tmp phase
% for iter=1:0
%     
%     eps=zeros(N,M);
%     for i=1:slices
%         tmp{i}=angle(s_fft(U0{i},M,N,lambda,z(i),xx0s{i},yy0s{i},xx,yy));
%         tmp{i}=i_fft(exp(1i.*tmp{i}),M,N,lambda,z(i),xx0s{i},yy0s{i},xx,yy); % Uideal
%         U0{i}=A0{i}.*exp(1i*angle(tmp{i})); 
%         eps=eps+abs(A0{i}-abs(tmp{i}));
%     end
%   
%    
% end

    U_slm=zeros(N,M);
    for i=1:slices
        U_slm=U_slm+s_fft(U0{i},M,N,lambda,z(i),xx0s{i},yy0s{i},xx,yy);
    end

    % move
    planex=-M/2:M/2-1;
    % planey=-N/2:N/2-1; %+planey'.*pi
    phase=angle(U_slm);
    phase=mod(phase+planex.*pi,2*pi);

    PhaseGraph=uint8(phase/2/pi*255);

    imwrite(PhaseGraph,[prefix,num2str(img_idx),'.bmp']);
    % reconstruction(tmp,10,1);
    img_idx
end