clear;clc;close all;

save_flag = 0;
n = 80;

%% init
np_xyzrgb = cube_init(n);
group_xyz = cube_group(np_xyzrgb);
pcshow(np_xyzrgb(:,1:3),np_xyzrgb(:,4:6));
axis([-5 5 -5 5 -5 5])
axis off;

%% rotate and save
npic = 1;
for times = 1:10
    group_move = zeros(1,3);
    temp1 = unidrnd(3);%rand int from 1 to 3
    temp2 = unidrnd(3);
    group_move(temp1) = temp2;
    angle = 3; %rotate 3°
    iters = 90/angle;
    for i = 1:iters
        np_xyzrgb = cube_rotate(np_xyzrgb,group_xyz,group_move,angle);
        pcshow(np_xyzrgb(:,1:3),np_xyzrgb(:,4:6));
        axis([-5 5 -5 5 -5 5])
        axis off;
        f = getframe(gca);
        f = frame2im(f);
        imwrite(f, ['./pictures/',num2str(npic),'.jpg']);
        if save_flag==1
            txtname = ['./txt/',num2str(npic),'.txt'];
            save_txt(np_xyzrgb,txtname);
        end
        npic = npic+1;
    end
    group_xyz = cube_group(np_xyzrgb);%update group information after 90°rotate
end
