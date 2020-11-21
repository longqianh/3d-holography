clear;clc;close all;
n=50;
cube=init(n,0.03);
a0=max(cube(:,1));
axlim=[-a0-1,a0+1,-a0-1,a0+1,-a0-1,a0+1];
axis(axlim);
pcshow(cube(:,1:3),cube(:,4:6));

for sur=[1,4,8]
    angle = 6; %rotate 6°
    iters = 90/angle;
    for i = 1:iters
        txtname=['./cubedata/cube_sur_',num2str(sur),'_rot_',num2str(angle*(i-1)),'.txt'];
        save_txt(cube,txtname);
        cube = rotate(cube,sur,angle);
        axis(axlim);
        pcshow(cube(:,1:3),cube(:,4:6));
        f=getframe(gca);
        
    end
    for i = 1:iters
        txtname=['./cubedata/cube_sur_',num2str(sur),'_rot_',num2str(angle*(i-1)),'.txt'];
        save_txt(cube,txtname);
        cube = rotate(cube,sur,-angle);
        axis(axlim);
        pcshow(cube(:,1:3),cube(:,4:6));
        f=getframe(gca);
    end
    
end
        