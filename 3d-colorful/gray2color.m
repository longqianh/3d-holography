% randomly add RGB channels to the grayscale data

function rgbmodel=gray2color(model)
[num,~]=size(model);
rgbmodel=cat(2,model,rand(num,1),rand(num,1),rand(num,1));

end