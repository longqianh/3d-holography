clear;clc;close all;
n = 50;
%% init
np_xyzrgb = cube_init(n);
group_xyz = cube_group(np_xyzrgb);
pcshow(np_xyzrgb(:,1:3),np_xyzrgb(:,4:6));
axis([-5 5 -5 5 -5 5])
axis off;

%% rotate and save
for times = 1:5
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
    end
    group_xyz = cube_group(np_xyzrgb);%update group information after 90°rotate
end
