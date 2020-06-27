% wait to add


clear;close all;
pictures=100;%--��Ƭ���в���
M = 1920; N = 1080;%���ֱ���
m0 = 0.5 ;  % ͼƬ�������� ��ֹ�ص�
lambda=0.532e-3;
z0 = 800;  %---y�������/mm
depth=30;  %---�������
pix=0.008;  %---SLM���ؿ��/mm
np=20;     %---��������

XY0=cell(pictures,1); %װ��Ƭ
z=1:pictures;
z=depth/pictures*z+z0;
for i=1:pictures
    XY0{i} = imread(['./tmp/' num2str(i) '.jpg']);
end

[U0,XY0,xx0,yy0,xx,yy]=initialize(XY0,M,N,m0,lambda,z0,pix);
% find(XY0{2})
Uf_slm=cell(pictures,1);
Uf_pic=cell(pictures,1);
Phase_pic=cell(pictures,1);
times=(np+1)*pictures;

for p=1:np+1 % GS-iteration
    Uf_sum_slm=zeros(N,M);
    for i=1:pictures
        Uf_slm{i}=s_fft(M,N,lambda,z(i),xx0,yy0,xx,yy,U0{i});
        Uf_sum_slm=Uf_sum_slm+Uf_slm{i};% complex applitudes superposition
    end
    Phase_slm=angle(Uf_sum_slm)+pi;%-��������Ӻ�ȡ��λ����Ϣͼ-% ȡangle��-pi~pi
    for i=1:pictures
        Uf_pic{i}=i_fft(M,N,lambda,z(i),xx0,yy0,xx,yy,Phase_slm);
        Phase_pic{i}=angle(Uf_pic{i});
        U0{i}=XY0{i}.*exp(1i*Phase_pic{i});
    end
    disp(p*pictures/times);
end

Ih=uint8(Phase_slm/2/pi*255);
% folder='./holo-graph';
% filename='holo-graph';
% [filename,folder] = uiputfile('*.bmp','save graph','holo-graph.bmp');
imwrite(Ih,'./holo-graph/holo-graph');

ii=1;
result=3*abs(Uf_pic{ii})/max(max(abs(Uf_pic{ii}))); % ����*3
result=imresize(result,[1000 1000]);
figure(1),imshow(result);
