function pog = calculate_single_color(rgbmodel,channel,z0,depth,slices,iter_num)

%  parameters 
M = 1920; N = 1080; % slm resolution: horizontal and vertical pixels
m0 = 0.5 ;  % image zoom factor: to prevent image superposition
pix=0.008;  % unit pixel width / mm
z=(1:slices)/slices*depth+z0; % different diffraction distance because of the depth of the object

% calculate 3d holography for the given channel
switch channel
    case 1 % red
        lambda = 532e-6; % 1nm = 1e-6 mm
    case 2 % green
        lambda=635e-6;
    otherwise %blue
        lambda=450e-6;
end


cutted=0;
if cutted == 0 
    single_channel_model=rgbmodel(:,[1:3,3+channel]);
    cutted_pieces=cut_pieces(single_channel_model,slices);
end

%  resize the slices and add random phase on each slice
[U0,A0,xx0,yy0,xx,yy]=initialize(cutted_pieces,M,N,m0,lambda,z0,pix);
U_slms=cell(slices,1);
U_pics=cell(slices,1);


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
        U_slms{i}=s_fft(U0{i},M,N,lambda,z(i),xx0,yy0,xx,yy);
%         if i<10
%             disp(mean(mean(U_slms{i})));
%         end
        U_slm=U_slm+U_slms{i};% complex applitudes superposition 
    end

    phase=angle(U_slm)+pi;% takeout angle to get phase graph, angle is range from -pi to pi
%     disp(mean(mean(phase)));
    for i=1:slices
        U_pics{i}=i_fft(exp(1i.*(phase-pi)),M,N,lambda,z(i),xx0,yy0,xx,yy);
        U0{i}=A0{i}.*exp(1i*(angle(U_pics{i}))); %+pi?
        
    end
    
%     disp(iter/iter_num);
    d.Value=iter/iter_num;
    d.Message = sprintf("Process: %.2f/1.00",d.Value);
end
d.Message="Done.";
pause(0.2);
close(d);
close(f);

pog=uint8(phase/2/pi*255);
% disp(mean(mean(pog)));  %127.4813

% imwrite(pog,"app.bmp");
% exit;
% pog=cat(3,pog,pog,pog);

