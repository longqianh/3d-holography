% model = load('../datas/bunny.txt');
% figure;
% pcshow(model);
% figure;
% pcshow(rotm(model,90,0,0));
function model = rotm(model,x,y,z)
% clock-wise
% x=-x;y=-y;
x=x/180*pi;
y=y/180*pi;
z=z/180*pi;
Rx=[1 0 0;0 cos(x) -sin(x);0 sin(x) cos(x)];
Ry=[cos(y) 0 sin(y);0 1 0;-sin(y) 0 cos(y)];
Rz=[cos(z) -sin(z) 0;sin(z) cos(z) 0;0 0 1];
model(:,1:3)=(Rx*Ry*Rz*model(:,1:3)')';

end
