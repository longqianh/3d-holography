lambda=520e-6;
M=1920;N=1080;
pix=0.008; % 8um
n = 1:N;
m = 1:M;
LM=pix*M;
LN=pix*N;
x = ((m-1)/M-0.5)*LM;
y = ((n-1)/N-0.5)*LN;
[xx,yy] = meshgrid(x,y);


y=zeros(length(100:100:4000),N,M);
x=zeros(length(100:100:4000),N,M);
x_encodez=zeros(length(100:100:4000),N,M);
y_encodez=zeros(length(100:100:4000),N,M);

for batch=7:10
    i=1;
    batch
for z=100:100:4000
    L=lambda*z/pix;
    x0 = ((m-1)/M-0.5)*L;
    y0 = ((n-1)/N-0.5)*L;
    [xx0,yy0] = meshgrid(x0,y0);
    x(i,:,:)=rand(N,M)*255; % x--training target
    x_encodez(i,:,:)=x(i,:,:);
%     [mx,id]=max(max(x_encodez(i,:,:)));
%     x_encodez(i,id)=x_encodez(i,id)*1/z;
    x_encodez(i,x_encodez(i,:,:)==0)=255*1/z;
    y(i,:,:)=s_fft(squeeze(exp(1i.*x(i,:,:))),M,N,lambda,z,xx0,yy0,xx,yy);
    y_encodez(i,:,:)=s_fft(squeeze(exp(1j.*x_encodez(i,:,:))),M,N,lambda,z,xx0,yy0,xx,yy);
    i=i+1;
   
end
    save(['./training_set/',num2str(batch),'_training_target_','.mat'],'y','-v7.3');
    save(['./training_set/',num2str(batch),'_training_input_','.mat'],'x','-v7.3');
    save(['./training_set/',num2str(batch),'_training_target_','encodez_','.mat'],'y_encodez','-v7.3');
    save(['./training_set/',num2str(batch),'_training_input_','encodez_','.mat'],'x_encodez','-v7.3');
end


