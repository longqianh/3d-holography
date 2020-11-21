function cube = init(n,eps)

% n=80; %  线密度
cube=zeros(n^3,6);

C=zeros(6,3); % R L U D F B
C(1,:)=[250,227,10]; % yellow 
C(2,:)=[255,245,247]; % white
C(3,:)=[30,150,255]; % blue
C(4,:)=[60,242,60]; % green
C(5,:)=[205,124,60]; % orange
C(6,:)=[255,69,0]; % red
C=C/255.0;
a0=3;b0=3;c0=3;
% eps=0.05;
a=linspace(-a0,a0,n);
[x,y,z]=meshgrid(a,a,a);
cube=reshape(cube,n,n,n,6);

for i=1:n
    for j=1:n
        for k=1:n
            if (x(i,j,k)<a0/3+eps && x(i,j,k)>a0/3-eps) || (x(i,j,k)<-a0/3+eps && x(i,j,k)>-a0/3-eps) ||...
                    (y(i,j,k)<a0/3+eps && y(i,j,k)>a0/3-eps) || (y(i,j,k)<-a0/3+eps && y(i,j,k)>-a0/3-eps) ||...
                     (z(i,j,k)<a0/3+eps && z(i,j,k)>a0/3-eps) || (z(i,j,k)<-a0/3+eps && z(i,j,k)>-a0/3-eps)
            else
                cube(i,j,k,:)=[x(i,j,k),y(i,j,k),z(i,j,k),0,0,0];
            end
            
            if x(i,j,k)>c0-eps 
                cube(i,j,k,4:6)=C(1,:);
            elseif x(i,j,k)<-c0+eps
                cube(i,j,k,4:6)=C(2,:);
            elseif y(i,j,k)>b0-eps
                cube(i,j,k,4:6)=C(3,:);
            elseif y(i,j,k)<-b0+eps
                cube(i,j,k,4:6)=C(4,:);
            elseif z(i,j,k)<-a0+eps
                cube(i,j,k,4:6)=C(5,:);
            elseif z(i,j,k)>a0-eps
                cube(i,j,k,4:6)=C(6,:);
            end            
            
        end
    end
end
cube=reshape(cube,n^3,6);

% cube
% figure;
% pcshow(cube(:,1:3),cube(:,4:6));
% axis([-5 5 -5 5 -5 5])
% axis off;
end

