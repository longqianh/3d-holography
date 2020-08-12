% ���� Preprocess_z(�����Ų�ɫͶӰԤ����)
% ����: ��һ��������״ unsigned int ���͵�ͼƬ,
%       �������ʺϴ������ߴ�, ��ת��Ϊ������,
%       ��ӻ�۵�������λ, ����Ϊf,
%       ��Ӧ��Ĳ���Ϊ h
% ע��: ֻ������������ͼ��
function U = Preprocess_z(X0,M,N,xx,yy,s,h,f,mode)
b=rand(0,1);
% ͼ������ʵ����Ͳ���
X1 = imresize(X0,[N*s M*s],'bicubic');
[N1,M1] = size(X1);
X = zeros(N,M); 
X(N/2-N1/2+1:N/2+N1/2,M/2-M1/2+1:M/2+M1/2)=X1(1:N1,1:M1);

% ת�����ͣ�����������λ
Y = double(X);
U=Y;
if mode==1
    b=rand(N,M)*1.5*pi;
    U = U.*exp(1j.*b);
    %disp('���');
end
    p = -pi*(xx.^2 + yy.^2)/(h*f);   % ������λ
    U = U.*exp(1j.*p);  % ͼ�����������λ
    %disp('����');


