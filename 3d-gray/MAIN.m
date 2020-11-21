clear;clc;clf;
%  parameters
M = 1920; N = 1080; % slm resolution: horizontal and vertical pixels
slices=50; % number of slices
m0 = 1 ;  % image zoom factor: to prevent image superposition
lambda=520e-6; % wavelength of the light , 532nm = 532e-6 mm for green light
z0 = 800;  %distance between the defracted plane and observation screen / mm

depth= 30;  % depth / mm
pix=0.008;  % unit pixel width / mm
iter_times=1;     % iteration times % NOTE it seems that no iteration would be better
z=(1:slices)/slices*depth+z0; % different diffraction distance because of the depth of the object
L=lambda.*z/pix; % 观察面总长
%  load data
modelroot='../datas/common_3d_models/';
modelname='bunny';
model = load([modelroot,modelname,'.txt']);

%  cut pieces and get the slices
cutted_pieces=cut_pieces(model,slices); 

%  resize the slices and add random phase on each slice
[U0,A0,xx0s,yy0s,xx,yy]=initialize(cutted_pieces,M,N,m0,L,pix); 

% GS iteration
tmp=cell(slices,1); % tmp phase
for iter=1:0
    
    eps=zeros(N,M);
    parfor i=1:slices
        tmp{i}=angle(s_fft(U0{i},M,N,lambda,z(i),xx0s{i},yy0s{i},xx,yy));
        tmp{i}=i_fft(exp(1i.*tmp{i}),M,N,lambda,z(i),xx0s{i},yy0s{i},xx,yy); % Uideal
        U0{i}=A0{i}.*exp(1i*angle(tmp{i})); 
        eps=eps+abs(A0{i}-abs(tmp{i}));
    end
   
end

U_slm=zeros(N,M);
parfor i=1:slices
    U_slm=U_slm+s_fft(U0{i},M,N,lambda,z(i),xx0s{i},yy0s{i},xx,yy);
end

% move
planex=-M/2:M/2-1;
planey=-N/2:N/2-1;
phase=angle(U_slm);
phase=mod(phase+planey'.*pi+planex.*pi,2*pi);

PhaseGraph=uint8(phase/2/pi*255);
% PhaseGraph=uint8(phase);
% disp(mean(mean(PhaseGraph))); % for debug
% [modelname,folder] = uiputfile('*.bmp','save graph','holo-graph.bmp');
imwrite(PhaseGraph,[modelname,'.bmp']);%../holo-graph/holo-graph
% reconstruction(tmp,10,1);
