function [U0,A0]=initialize(slices,N,M)
% pack the slices into U0 and add random phase for each slice
U0=cell(slices,1);
A0=cell(slices,1);
for i=1:slices
    A = imresize(imread(['../tmp/' num2str(i) '.jpg']),[N,M]);
    A=double(A)/255;
    phase=rand(N,M)*2*pi; %add random phase
    U0{i}=A.*exp(1i.*phase);  %inital complex amplitudes for later iterations
    A0{i}=abs(U0{i}); 
end

end