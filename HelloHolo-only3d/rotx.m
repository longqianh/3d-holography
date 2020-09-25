function model = rotx(model,x)
% clock-wise
x=-x;
Rx=[1 0 0;0 cos(x) -sin(x);0 sin(x) cos(x)];
model=model*Rx;
end