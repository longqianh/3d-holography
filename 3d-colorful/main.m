% 3d colorful holography


% parameters

% load data and divide into 3 channels


% calculate 3d holography for each channel
R_phasegraph = 3dgray();
G_phasegraph = 3dgray();
B_phasegraph = 3dgray();

% combine the RGB components together
RGB_phasegraph=R_phasegraph+G_phasegraph+B_phasegraph;
