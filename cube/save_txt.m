function save_txt(ptcloud,txtname)

fid = fopen(txtname,'wt+');

[m,n]=size(ptcloud);
for i=1:m
    for j=1:n
        if j==n 
            fprintf(fid,'%1.2f\n',ptcloud(i,j));
        else
            fprintf(fid,'%1.2f\t',ptcloud(i,j));
        end
    end
end
fclose(fid);

end