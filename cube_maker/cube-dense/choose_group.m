function [group,group_idx] = make_group(cube,surface)

% 123 x, 456 y, 789 z

a0=max(cube(:,1));
axis=floor((surface-1)/3)+1;

switch mod(surface,3)
    case 0
        group_idx=cube(:,axis)<-a0/3;
        group=cube(group_idx,1:3);
    case 1
        group_idx=cube(:,axis)>-a0/3&cube(:,axis)<a0/3;
        group=cube(group_idx,1:3);
    case 2
        group_idx=cube(:,axis)>a0/3;
        group=cube(group_idx,1:3);
        
end
end