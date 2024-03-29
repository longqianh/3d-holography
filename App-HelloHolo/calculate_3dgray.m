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

    phase=angle(U_slm)+pi;% takeout angle to get pahse graph, angle is range from -pi to pi
    for i=1:slices
        tmp=i_fft(exp(1i.*(phase-pi)),M,N,lambda,z(i),xx0s{i},yy0s{i},xx,yy);
        U0{i}=A0{i}.*exp(1i*(angle(tmp))); 
    end
    disp(iter/iter_num);
    d.Value=iter/iter_num;
    d.Message = sprintf("Process: %.2f/1.00",d.Value);
end
% GS iteration
% U_slms=cell(slices,1);
% U_pics=cell(slices,1);
% for iter=1:iter_num
%     if d.CancelRequested
%             break
%     end
%     U_slm=zeros(N,M);
%     for i=1:slices
%         U_slms{i}=s_fft(U0{i},M,N,lambda,z(i),xx0s{i},yy0s{i},xx,yy);
%         U_slm=U_slm+U_slms{i};% complex applitudes superposition 
%     end
% 
%     phase=angle(U_slm)+pi;% takeout angle to get phase graph, angle is range from -pi to pi
%     for i=1:slices
%         U_pics{i}=i_fft(exp(1i.*(phase-pi)),M,N,lambda,z(i),xx0s{i},yy0s{i},xx,yy);
%         U0{i}=A0{i}.*exp(1i*(angle(U_pics{i}))); %+pi?
%         
%     end
    
%     disp(iter/iter_num);
    
% end
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

