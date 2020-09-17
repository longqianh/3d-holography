function cut_pieces(model,mcolor,slices)
% disp(mean(mean(model)));
% Cut pieces from 3-D objects.
% INPUT: number of slices -- n
% OUT: write images of slices into tmp file

%sort by z coordinate
ver=sortrows(cat(2,model,mcolor),3);
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
ver1=ver(1:ceil(num/slices):num,:);
z1=ver1(:,3);
figure;

for k=1:3
for i = 1:length(z1)
    if i<length(z1) 
     % add all the points whose z within the z-range
        xy=ver(ver(:,3)>z1(i)&ver(:,3)<z1(i+1),[1:2,k]); 
        
    else % the last z-range
        xy=ver(ver(:,3)>z1(i),[1:2,k]);
    end
    
    scatter(xy(:,1),xy(:,2),8,xy(:,3),'filled');  
    axis equal;
    axis([XMIN XMAX YMIN YMAX]) 
    axis off;
    set(gcf, 'Color', 'black');
    f = getframe(gca);
    f = frame2im(f); 
    f = rgb2gray(f);
    imwrite(f, ['../tmp/' num2str(k) num2str(i) '.jpg']);

end
end
    pause(0.1);
    close;
end