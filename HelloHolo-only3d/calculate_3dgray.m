function [pog,rcst_img]=calculate_3dgray(model,lambda,z0,depth,slices,iter_num,m0)

%  parameters 
M = 1920; N = 1080; % slm resolution: horizontal and vertical pixels
% m0 = 0.5 ;  % image zoom factor: to prevent image superposition
pix=0.008;  % unit pixel width / mm
z=(1:slices)/slices*depth+z0; % different diffraction distance because of the depth of the object
L=lambda.*z/pix; % length of the observation plane
%  cut pieces and get the slices
cutted_pieces=cut_pieces(model,slices); 

%  resize the slices and add random phase on each slice
[U0,A0,xx0s,yy0s,xx,yy]=initialize(cutted_pieces,M,N,m0,L,pix);

f = uifigure;
d = uiprogressdlg(f,'Title','Calculating Phase Only Graph',...
        'Message','Please wait...','Cancelable','on');
    
% planex=-M/2:M/2-1;

    % GS iteration
for iter=1:iter_num
     if d.CancelRequested
            break
    end
    U_slm=zeros(N,M);
    for i=1:slices
        tmp=s_fft(U0{i},M,N,lambda,z(i),xx0s{i},yy0s{i},xx,yy);
        U_slm=U_slm+tmp;% complex applitudes superposition 
    end

    phase=angle(U_slm);% takeout angle to get pahse graph, angle is range from -pi to pi
%     phase=mod(phase+pi.*planex,2*pi);
    for i=1:slices
        tmp=i_fft(exp(1i.*phase),M,N,lambda,z(i),xx0s{i},yy0s{i},xx,yy);
        U0{i}=A0{i}.*exp(1i*(angle(tmp))); 
    end
  
   d.Value=iter/iter_num;
   d.Message = sprintf("Process: %.2f/1.00",d.Value);
   disp(d.Value);
  
   
end
% 
% eps=1;
% tmp=zeros(slices,1); % tmp phase
% while eps<0.001
%      if d.CancelRequested
%             break
%     end
% 
%     
%     eps=0;
%     for i=1:slices
%         tmp(i)=angle(s_fft(U0{i},M,N,lambda,z(i),xx0s{i},yy0s{i},xx,yy));
%         Uideal=i_fft(exp(1i.*(tmp(i)-pi)),M,N,lambda,z(i),xx0s{i},yy0s{i},xx,yy);
%         tmp(i)=angle(Uideal);
%         U0{i}=A0{i}.*exp(1i*(angle(tmp(i)))); 
%         eps=eps+abs(A0{i}-abs(Uideal));
%     end
% %     eps
% 
% %     phase=angle(U_slm)+pi;% takeout angle to get pahse graph, angle is range from -pi to pi
%        
%   
%    d.Value=iter/iter_num;
%    d.Message = sprintf("Process: %.2f/1.00",d.Value);
%    disp(d.Value);
%   
%    
% end

% U_slm=zeros(N,M);
% for i=1:slices
%     U_slm=U_slm+s_fft(U0{i},M,N,lambda,z(i),xx0s{i},yy0s{i},xx,yy);
% end
% phase=angle(U_slm);


d.Message="Done.";
pause(0.2);
close(d);
close(f);

pog=uint8(phase/2/pi*255);
% disp(mean(mean(pog)));  %127.4813

% imwrite(pog,"app.bmp");
% exit;
pog=cat(3,pog,pog,pog);
rcst_img=reconstruction(tmp,6);
% rcst -- reconstruction image

% brightness=3;
% pic_num=1;
% simu_res=brightness*abs(U_pics{pic_num})/max(max(abs(U_pics{pic_num}))); 
% simu_res=imresize(simu_res,[1000 1000]);
% imshow(simu_res);

