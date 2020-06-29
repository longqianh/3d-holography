% 3d colorful holography

% load data and divide into 3 channels
modelpath='../datas/bunny.txt';
model = load(modelpath);
rgbmodel=gray2color(model);

% calculate 3d holography for each channel
r_phasegraph=calculate_single_color(rgbmodel,1);
g_phasegraph=calculate_single_color(rgbmodel,2);
b_phasegraph=calculate_single_color(rgbmodel,3);

% combine the RGB components together
RGB_phasegraph1=r_phasegraph+g_phasegraph+b_phasegraph;
M=1920;
RGB_phasegraph2(:,1:M/3)=r_phasegraph(:,1:M/3);
RGB_phasegraph2(:,M/3+1:M/3*2)=g_phasegraph(:,M/3+1:M/3*2);
RGB_phasegraph2(:,M/3*2+1:M)=b_phasegraph(:,M/3*2+1:M);
imwrite(RGB_phasegraph1,['phase-only-img-i-s' ,' superposition ', '.bmp'] );
imwrite(RGB_phasegraph2,['phase-only-img-i-s' ,' spacedividing ', '.bmp'] );
