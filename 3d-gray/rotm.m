% model = load('../datas/bunny.txt');
% figure;
% pcshow(model);
% figure;
% pcshow(rotm(model,90,0,0));
function model = rotm(model,x,y,z)
% clock-wise
x=-x;y=-y;
Rx=[1 0 0;0 cos(x) -sin(x);0 sin(x) cos(x)];
Ry=[cos(y) 0 sin(y);0 1 0;-sin(y) 0 cos(y)];
Rz=[cos(z) -sin(z) 0;sin(z) cos(z) 0;0 0 1];
model=model*Rx*Ry*Rz;

end
