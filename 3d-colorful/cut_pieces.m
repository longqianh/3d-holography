function cut_pieces(model,slices)
% cut pieces by z coordinate from 3D model
% input
% 3D model and slices to cut
% output 
% None
% auto-save intensity graph into tmp file which will be used further

    %sort by z coordinate
    ver=sortrows(model(:,1:4),3);
    ver_num=size(ver,1); % number of points
    % move z coordinate to 0
    minz=min(ver(:,3));
    ver(:,3)=ver(:,3)-minz;
    xmin=min(ver(:,1));
    xmax=max(ver(:,1));
    ymin=min(ver(:,2));
    ymax=max(ver(:,2));

    ver1=ver(1:floor(ver_num/slices)+1:ver_num,:);
    z1=ver1(:,3);
    for i = 1:length(z1)
            if i<length(z1) 
           % add all the ver whose z within the z-range
            xy=ver(ver(:,3)>z1(i)&ver(:,3)<z1(i+1),[1:2,4]);   
            else % the last z-range
                xy=ver(ver(:,3)>z1(i),[1:2,4]);
            end

            % RGB image with three channels equal is grayscale
            % RGB2GRAY fomula : I =  0.2989 * R + 0.5870 * G + 0.1140 * B
            c=repmat(xy(:,3),1,3);
%             c(:,1)=c(:,1)/0.2989;
%             c(:,2)=c(:,2)/0.5870;
%             c(:,3)=c(:,3)/0.1140;

            scatter(xy(:,1),xy(:,2),50,c,'.');
            axis equal;
            axis([xmin xmax ymin ymax]) ;
            axis off;
            f = getframe(gca);
            f = frame2im(f); 
            f = rgb2gray(f);
            imwrite(f, ['../tmp/' num2str(i) '.jpg']);    
   
    end
end
