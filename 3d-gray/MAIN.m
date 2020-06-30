%  parameters 
M = 1920; N = 1080; % slm resolution: horizontal and vertical pixels
slices=100; % number of slices
m0 = 0.5 ;  % image zoom factor: to prevent image superposition
lambda=0.532e-3; % wavelength of the light , 532nm for green light
z0 = 800;  %distance between the defracted plane and observation screen

depth=30;  % depth
pix=0.008;  % unit pixel width
iter_num=20;     % number of iterations


%  load data
model = load('../datas/bunny.txt');


%  cut pieces
cut_pieces(model,slices); 

XY0=cell(slices,1); %pack the slices 
z=(1:slices)/slices*depth+z0; % different diffraction distance because of the depth of the object
for i=1:slices
    XY0{i} = imread(['../tmp/' num2str(i) '.jpg']);
end

%  resize the slices and add random phase
[U0,A0,xx0,yy0,xx,yy]=initialize(XY0,M,N,m0,lambda,z0,pix);

U_slms=cell(slices,1);
U_pics=cell(slices,1);
PhaseGraphs=cell(slices,1);
times=(iter_num+1)*slices;

for iter=1:iter_num+1  
    U_slm=zeros(N,M);
    for i=1:slices
        U_slms{i}=s_fft(M,N,lambda,z(i),xx0,yy0,xx,yy,U0{i});
        U_slm=U_slm+U_slms{i};% complex applitudes superposition 
        
    end
    abs(U_slm)
    Phase_slm=angle(U_slm)+pi;% takeout angle to get pahse graph, angle is range from -pi to pi
    
    for i=1:slices
        U_pics{i}=i_fft(M,N,lambda,z(i),xx0,yy0,xx,yy,Phase_slm);
        PhaseGraphs{i}=angle(U_pics{i});
        U0{i}=A0{i}.*exp(1i*PhaseGraphs{i});
    end
    disp(iter*slices/times); % running progress 
end

Ih=uint8(Phase_slm/2/pi*255);
% [filename,folder] = uiputfile('*.bmp','save graph','holo-graph.bmp');
imwrite(Ih,'phase-only-img.bmp');%../holo-graph/holo-graph


brightness=3;
pic_num=i;
res=brightness*abs(U_pics{pic_num})/max(max(abs(U_pics{pic_num}))); 
res=imresize(res,[1000 1000]);
figure;
imshow(res);
