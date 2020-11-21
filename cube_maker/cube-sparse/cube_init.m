function np_xyzrgb = cube_init(n)
% initialize six faces of the cube
% n : side point num of single face's 1/9part 
% np_xyzrgb : xyzrgb of 54*n*n points

%n = 80;
temp_x = linspace(-3,3,n*3);
temp_y = temp_x;
xyzrgb_1 = zeros(9*n*n,6);
k=1;
for i=1:n*3
    for j=1:n*3
        xyzrgb_1(k,1)=temp_x(i);
        xyzrgb_1(k,2)=temp_y(j);
        k=k+1;
    end
end
xyzrgb_1(:,3)=3;
xyzrgb_1(:,4)=1;
xyzrgb_1(:,5)=0.5;
xyzrgb_1(:,6)=0;
temp_id=(xyzrgb_1(:,1)>0.95 & xyzrgb_1(:,1)<1.05);
xyzrgb_1(temp_id,:)=[];
temp_id=(xyzrgb_1(:,2)>0.95 & xyzrgb_1(:,2)<1.05);
xyzrgb_1(temp_id,:)=[];
temp_id=(xyzrgb_1(:,1)<-0.95 & xyzrgb_1(:,1)>-1.05);
xyzrgb_1(temp_id,:)=[];
temp_id=(xyzrgb_1(:,2)<-0.95 & xyzrgb_1(:,2)>-1.05);
xyzrgb_1(temp_id,:)=[];

xyzrgb_2 = xyzrgb_1;
xyzrgb_2(:,3)=-xyzrgb_2(:,3);
xyzrgb_1(:,4)=1;
xyzrgb_1(:,5)=0;
xyzrgb_1(:,6)=0;

xyzrgb_3 = xyzrgb_1;
xyzrgb_3(:,[2,3])=xyzrgb_3(:,[3,2]);
xyzrgb_3(:,4)=1;
xyzrgb_3(:,5)=1;
xyzrgb_3(:,6)=0;

xyzrgb_4 = xyzrgb_3;
xyzrgb_4(:,2) = -xyzrgb_4(:,2);
xyzrgb_4(:,4)=1;
xyzrgb_4(:,5)=1;
xyzrgb_4(:,6)=1;

xyzrgb_5 = xyzrgb_1;
xyzrgb_5(:,[1,3])=xyzrgb_5(:,[3,1]);
xyzrgb_5(:,4)=0;
xyzrgb_5(:,5)=0;
xyzrgb_5(:,6)=1;

xyzrgb_6 = xyzrgb_5;
xyzrgb_6(:,1) = -xyzrgb_6(:,1);
xyzrgb_6(:,4)=0;
xyzrgb_6(:,5)=1;
xyzrgb_6(:,6)=0;

np_xyzrgb=[xyzrgb_1;xyzrgb_2;xyzrgb_3;xyzrgb_4;xyzrgb_5;xyzrgb_6];
%pcshow(np_xyzrgb(:,1:3),np_xyzrgb(:,4:6));

