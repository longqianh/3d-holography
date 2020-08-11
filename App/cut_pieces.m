function cutted_pieces=cut_pieces(model,slices)

% Cut pieces from 3-D objects.
% INPUT: number of slices -- n
% OUT: write images of slices into tmp file

%sort by z coordinate
cutted_pieces=cell(slices,1);
ver=sortrows(model,3);
X=ver(:,1);
Y=ver(:,2);
num=size(X,1);
XMIN=min(X);
XMAX=max(X);
YMIN=min(Y);
YMAX=max(Y);

% adjust z coordinate
min_z=min(ver(:,3));
ver(:,3)=ver(:,3)-min_z;

% get z-range of one slice per layer
ver1=ver(1:ceil(num/slices):num,:); % ver1=ver(1:floor(num/slices):num,:);
z1=ver1(:,3);

figure; % 大 BUG ！！！

for i = 1:length(z1)
    if i<length(z1) 
     % add all the points whose z within the z-range
        xy=ver(ver(:,3)>z1(i)&ver(:,3)<z1(i+1),1:2);   
    else % the last z-range
        xy=ver(ver(:,3)>z1(i),1:2);
    end
%     color=rand(length(xy(:,1)),3);
%     scatter(xy(:,1),xy(:,2),10,color,'filled'); 
    
    scatter(xy(:,1),xy(:,2),8,'white','filled');  
    axis equal;
    axis([XMIN XMAX YMIN YMAX]) 
    axis off;
    set(gcf, 'Color', 'black');
    frame = getframe(gca);
    frame = frame2im(frame); 
    frame = rgb2gray(frame);
    imwrite(frame, ['./' num2str(i) '.jpg']);

end

close;
for i=1:slices
    cutted_pieces{i}=imread(['./' num2str(i) '.jpg']);
    delete(['./' num2str(i) '.jpg']);
    
end

end