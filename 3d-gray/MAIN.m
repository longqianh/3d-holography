% waiting to add
clc;clear;

% ### parameters 
M = 1920; N = 1080; % slm resolution: horizontal and vertical pixels
pictures=100; % number of slices
m0 = 0.5 ;  % image zoom factor: to prevent image superposition
lambda=0.532e-3; % wavelength of the light , 532nm for green light
z0 = 800;  %distance between the defracted plane and observation screen

depth=30;  %---立体深度
pix=0.008;  % unit pixel width
iter_num=20;     % number of iterations

% ### cut pieces
cut_pieces(pictures); 

XY0=cell(pictures,1); %pack the slices 
z=(1:pictures)/pictures*depth+z0; % different diffraction distance because of the depth of the object
for i=1:pictures
    XY0{i} = imread(['../tmp/' num2str(i) '.jpg']);
end

% ### resize the slices and add random phase
[U0,A0,xx0,yy0,xx,yy]=initialize(XY0,M,N,m0,lambda,z0,pix);

Uf_slm=cell(pictures,1);
Uf_pic=cell(pictures,1);
Phase_pic=cell(pictures,1);
times=(iter_num+1)*pictures;

for iter=1:iter_num+1  % GS iteration
    Uf_sum_slm=zeros(N,M);
    for i=1:pictures
        Uf_slm{i}=s_fft(M,N,lambda,z(i),xx0,yy0,xx,yy,U0{i});
%     Uf_slm{i}=fresnel_int(M,N,lambda,z(i),xx0,yy0,xx,yy,U0{i}); % try
        Uf_sum_slm=Uf_sum_slm+Uf_slm{i};% complex applitudes superposition 
        
    end
    Phase_slm=angle(Uf_sum_slm)+pi;% takeout angle to get pahse graph, angle is range from -pi to pi
    
    % 还原？
    for i=1:pictures
        Uf_pic{i}=i_fft(M,N,lambda,z(i),xx0,yy0,xx,yy,Phase_slm);
        Phase_pic{i}=angle(Uf_pic{i});
        U0{i}=A0{i}.*exp(1i*Phase_pic{i});
    end
    disp(iter*pictures/times); % running progress 
end

Ih=uint8(Phase_slm/2/pi*255);
% [filename,folder] = uiputfile('*.bmp','save graph','holo-graph.bmp');
imwrite(Ih,'../holo-graph/holo-graph');


brightness=3;
pic_num=1;
res=brightness*abs(Uf_pic{pic-num})/max(max(abs(Uf_pic{pic_num}))); 
res=imresize(res,[1000 1000]);
figure;
imshow(res);
