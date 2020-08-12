function model = rotz(model,z)
% clock-wise
% z=-z; 加上反而变成逆时针了
Rz=[cos(z) -sin(z) 0;sin(z) cos(z) 0;0 0 1];
model=model*Rz;
end

