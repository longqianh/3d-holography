function np_xyzrgb = cube_rotate(np_xyzrgb,group_xyz,group_move,angle)
% rotate points of group_move

% group_move=[1 0 0];
angle = angle/180*pi;
r = [cos(angle),-sin(angle);sin(angle),cos(angle)];

if(group_move(1)~=0)
    temp_id = (group_xyz(:,1)==group_move(1));
    temp_yz = np_xyzrgb(temp_id,[2,3]);
    temp_yz = (r*(temp_yz'))';
    np_xyzrgb(temp_id,[2,3]) = temp_yz;
end

if(group_move(2)~=0)
    temp_id = (group_xyz(:,2)==group_move(2));
    temp_xz = np_xyzrgb(temp_id,[1,3]);
    temp_xz = (r*(temp_xz'))';
    np_xyzrgb(temp_id,[1,3]) = temp_xz;
end

if(group_move(3)~=0)
    temp_id = (group_xyz(:,3)==group_move(3));
    temp_xy = np_xyzrgb(temp_id,[1,2]);
    temp_xy = (r*(temp_xy'))';
    np_xyzrgb(temp_id,[1,2]) = temp_xy;
end

end