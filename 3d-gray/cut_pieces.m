clear;close;clc;
slices=100; % number of slices
cut=zeros(slices,1);
pictures=cell(slices);
% model=pcread('.datas/x-wing.ply');
model = load('./datas/bunny.txt');
%sort by z coordinate
% ver=sortrows(model.Location,3);
ver=sortrows(model,3);
X=ver(:,1);
Y=ver(:,2);
Z=ver(:,3);
num=size(X,1);

% adjust z coordinate
min_z=min(ver(:,3));
ver(:,3)=ver(:,3)-min_z;

% get z-range of one slice per layer
ver1=ver(1:floor(num/slices):num,:);
z1=ver1(:,3);

XMIN=min(X);
XMAX=max(X);
YMIN=min(Y);
YMAX=max(Y);

for i = 1:length(z1)
    if i<length(z1) 
     % add all the points whose z within the z-range
    xy=ver(ver(:,3)>z1(i)&ver(:,3)<z1(i+1),1:2);   
    else % the last z-range
        xy=ver(ver(:,3)>z1(i),1:2);
    end
    
    scatter(xy(:,1),xy(:,2),9,'w','filled'); % scatter VS plot sz=9 
    axis equal;
    axis([XMIN XMAX YMIN YMAX]) 
    axis off;
    set(gcf, 'Color', 'black');
    f = getframe(gca);
    f = frame2im(f); 
    f = rgb2gray(f);
    imwrite(f, ['./tmp/' num2str(i) '.jpg']);    
    
end

