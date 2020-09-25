function model = roty(model,y)
% clock-wise
y=-y;
Ry=[cos(y) 0 sin(y);0 1 0;-sin(y) 0 cos(y)];
model=model*Ry;
end