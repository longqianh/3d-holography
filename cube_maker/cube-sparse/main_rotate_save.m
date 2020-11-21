clear;clc;close all;
save_flag = 1;
n = 50;
%% init
np_xyzrgb = cube_init(n);
np = size(np_xyzrgb,1);
group_xyz = cube_group(np_xyzrgb);
pcshow(np_xyzrgb(:,1:3),np_xyzrgb(:,4:6));
axis([-5 5 -5 5 -5 5])
axis off;

%% rotate and save
npic = 1;
for times = 1:1
    group_move = zeros(1,3);
    temp1 = unidrnd(3);%rand int from 1 to 3
    temp2 = unidrnd(3);
    group_move(temp1) = temp2;
    angle = 6; %rotate 6°
    iters = 90/angle;
    for i = 1:iters
        np_xyzrgb = cube_rotate(np_xyzrgb,group_xyz,group_move,angle);
        pcshow(np_xyzrgb(:,1:3),np_xyzrgb(:,4:6));
        axis([-5 5 -5 5 -5 5])
        axis off;
        f = getframe(gca);
        if save_flag==1
            f = frame2im(f);
            imwrite(f, ['./cubes/',num2str(npic),'.jpg']);
            txtname = ['./txt/',num2str(npic),'.txt'];
            group_move_temp = [1,0,1];
            group_temp = ones(np,3);
            xyzrgb = cube_rotate(np_xyzrgb,group_temp,group_move_temp,30);
            save_txt(xyzrgb,txtname);
        end
        npic = npic+1;
    end
    group_xyz = cube_group(np_xyzrgb);%update group information after 90°rotate
end

%% show xyzrgb saved
 pcshow(xyzrgb(:,1:3),xyzrgb(:,4:6));
 axis([-5 5 -5 5 -5 5])
 view([0,0]);
 
 