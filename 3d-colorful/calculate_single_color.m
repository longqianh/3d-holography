function PhaseGraph = calculate_single_color(rgbmodel,channel)

% parameters
M = 1920; N = 1080; % slm resolution: horizontal and vertical pixels
slices=100; % number of slices
m0 = 0.5 ;  % image zoom factor: to prevent image superposition
z0 = 800;  %distance between the defracted plane and observation screen
depth=30;  % depth 
pix=0.008;  % unit pixel width
z=z0+(1:slices)*depth; % depth of each slice on the observation pla
LM = M*pix; 
LN = N*pix;
n = 1:N;
m = 1:M;

% diffraction plane points
dx0=pix;
dy0=pix;
x0 = ((m-1)/m-0.5)*dx0;
y0 = ((n-1)/n-0.5)*dy0;
[xx0,yy0] = meshgrid(x0,y0);

% calculate 3d holography for the given channel
switch channel
    case 1 % red
        lambda = 532e-6; % 1nm = 1e-6 mm
    case 2 % green
        lambda=635e-6;
    otherwise %blue
        lambda=450e-6;
end

% generate observation plane points
dx=lambda*z0/LM;
dy=lambda*z0/LN;
x = ((m-1)/m-0.5)*dx;
y = ((n-1)/n-0.5)*dy;
[xx,yy] = meshgrid(x,y);

cutted=1;
if cutted == 0 
    single_channel_model=rgbmodel(:,[1:3,3+channel]);
    cut_pieces(single_channel_model,slices);
end

% Method 1
% GS iteration for each picture
% PhaseGraph=zeros(N,M);
% 
% for i=1:slices
%     U0 =imresize(imread(['../tmp/' num2str(i) '.jpg']),[N,M]);
%     A0=double(U0)/255; % source intensity
%     PhaseGraph=PhaseGraph+GS_iteration(A0,M,N,lambda,z(i),xx0,yy0,xx,yy);
%     disp(i*iter/(slices*iter_num)); % running progress 
% end

% Method 2
% GS iteration for the final phase graph
%  resize the slices and add random phase
[U0,A0]=initialize(slices,N,M);

U_slms=cell(slices,1);
U_pics=cell(slices,1);
iter_num=20;
for iter=1:iter_num  % GS iteration 
    U_slm=zeros(N,M);
    for i=1:slices
        U_slms{i}=s_fft(U0{i},M,N,lambda,z(i),xx0,yy0,xx,yy);
        U_slm=U_slm+U_slms{i};% complex applitudes superposition       
    end
    
    for i=1:slices
        U_pics{i}=i_fft(angle(U_slm),M,N,lambda,z(i),xx0,yy0,xx,yy); % z(i) takes depth into account
        U0{i}=A0{i}.*exp(1i*angle(U_pics{i}));
    end
    disp(iter*i/(iter_num*slices)); % running progress 
end

PhaseGraph=uint8(angle(U_slm)/2/pi*255);
imwrite(PhaseGraph,'phase-only-img.bmp');%../holo-graph/holo-graph
% [filename,folder] = uiputfile('*.bmp','save graph','holo-graph.bmp');

simu=1;
% Simulated reduction
if simu==1
    B=3; % intensity factor
    pic_num=1; %
    res=B*abs(U_pics{pic-num})/max(max(abs(U_pics{pic_num}))); 
    res=imresize(res,[1000 1000]);
    figure;
    imshow(res);
end




 end