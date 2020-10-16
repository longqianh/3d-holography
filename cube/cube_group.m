function group_xyz = cube_group(np_xyzrgb)
% find points belong to which group (x1 x2 x3 y1 y2 y3 z1 z2 z3)

[n,~]=size(np_xyzrgb);
group_xyz = zeros(n,3);
%group_x
temp_x = np_xyzrgb(:,1);
temp_id = (temp_x<-1);
group_xyz(temp_id,1)=1;
temp_id = (temp_x>=-1 & temp_x<=1);
group_xyz(temp_id,1)=2;
temp_id = (temp_x>1);
group_xyz(temp_id,1)=3;

%group_y
temp_y = np_xyzrgb(:,2);
temp_id = (temp_y<-1);
group_xyz(temp_id,2)=1;
temp_id = (temp_y>=-1 & temp_y<=1);
group_xyz(temp_id,2)=2;
temp_id = (temp_y>1);
group_xyz(temp_id,2)=3;

%group_z
temp_z = np_xyzrgb(:,3);
temp_id = (temp_z<-1);
group_xyz(temp_id,3)=1;
temp_id = (temp_z>=-1 & temp_z<=1);
group_xyz(temp_id,3)=2;
temp_id = (temp_z>1);
group_xyz(temp_id,3)=3;

end