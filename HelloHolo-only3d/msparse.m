% m=load("../datas/dragon.xyz");
% m1=sparse(m);
function model=msparse(model)
std=40000;
model=model(1:length(model)/std:length(model),:);


end