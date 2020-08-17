clear;clc;clf;
%  parameters
M = 1920; N = 1080; % slm resolution: horizontal and vertical pixels
slices=50; % number of slices
m0 = 0.5 ;  % image zoom factor: to prevent image superposition
lambda=520e-6; % wavelength of the light , 532nm = 532e-6 mm for green light
z0 = 800;  %distance between the defracted plane and observation screen / mm

depth= 30;  % depth / mm
pix=0.008;  % unit pixel width / mm
iter_times=1;     % iteration times % NOTE it seems that no iteration would be better
z=(1:slices)/slices*depth+z0; % different diffraction distance because of the depth of the object

%  load data
model = load('../datas/bunny.txt');

%  cut pieces and get the slices
cutted=0;
if cutted==0
    cut_pieces(model,slices); 
end

%  resize the slices and add random phase on each slice
[U0,A0,xx0,yy0,xx,yy]=initialize(slices,M,N,m0,lambda,z0,pix); 

% U_slms=cell(slices,1);
U_pics=cell(slices,1);

% GS iteration
for iter=1:iter_times
    U_slm=zeros(N,M);
    for i=1:slices

        tmp=s_fft(U0{i},M,N,lambda,z(i),xx0,yy0,xx,yy);
        U_slm=U_slm+tmp;% complex applitudes superposition 
    end

    phase=angle(U_slm)+pi;% takeout angle to get pahse graph, angle is range from -pi to pi
    for i=1:slices
        tmp=i_fft(exp(1i.*(phase-pi)),M,N,lambda,z(i),xx0,yy0,xx,yy);
        U0{i}=A0{i}.*exp(1i*(angle(tmp))); 
        
    end
    disp(iter/iter_times);
end

PhaseGraph=uint8(phase/2/pi*255);
% disp(mean(mean(PhaseGraph))); % for debug
% [filename,folder] = uiputfile('*.bmp','save graph','holo-graph.bmp');
imwrite(PhaseGraph,'main.bmp');%../holo-graph/holo-graph
reconstruction(tmp,10,1);
