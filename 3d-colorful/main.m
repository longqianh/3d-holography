% 3d colorful holography

% load data and divide into 3 channels
modelpath='../datas/bunny.txt';
model = load(modelpath);
rgbmodel=gray2color(model);

% calculate 3d holography for each channel
r_phasegraph=calculate_single_color(rgbmodel,1);
% g_phasegraph=calculate_single_color(rgbmodel,2);
% b_phasegraph=calculate_single_color(rgbmodel,3);
% 
% % combine the RGB components together
% RGB_phasegraph=R_phasegraph+G_phasegraph+B_phasegraph;
% 划分一下