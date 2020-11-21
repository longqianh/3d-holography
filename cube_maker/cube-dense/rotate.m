function cube = rotate(cube,surface,angle)
% rotate points of group_move
% surface: 1~9 R,RLM,L, U,UDM,D, F,FBM,B
% direction: 0 -- clockwise, 1 -- anti-clockwise

angle = angle/180*pi;
% if direction
%     angle=-angle;
% end
% axis=1:3;
% a0=max(cube(:,1));
[group,group_idx] = choose_group(cube,surface);
axis=floor((surface-1)/3)+1;
switch axis
    case 1
       R= [1 0 0;0 cos(angle) -sin(angle);0 sin(angle) cos(angle)];
        cube(group_idx,1:3)=(R*group')';
    case 2
        R=[cos(angle) 0 sin(angle);0 1 0;-sin(angle) 0 cos(angle)];
        cube(group_idx,1:3)=(R*group')';
    case 3
        R=[cos(angle) -sin(angle) 0;sin(angle) cos(angle) 0;0 0 1];
        cube(group_idx,1:3)=(R*group')';

% axis=axis(axis~=tmp);
% cube(group_idx,axis)=(R*group(:,axis)')';

end