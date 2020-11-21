# from model import SimpleCGH
import models
from torch.utils.data import DataLoader
import torch.nn as nn
import torch
from torchnet import meter
from config import DefaultConfig
import torch.nn.functional as F
from utils.visualize import Visualizer
from data.dataset import CGHData
opt=DefaultConfig()



def train(**kwargs):
    opt.parse(kwargs)
    vis=Visualizer(opt.env)
    Model=getattr(models,opt.model)
    model=Model(40)
    if opt.load_model_path:
        model.load(opt.load_model_path)
    if opt.use_gpu: model.cuda()

    train_data=CGHData(opt.train_data_root,train=True)
    val_data=CGHData(opt.train_data_root,train=False)
    train_dataloader=DataLoader(train_data,opt.batch_size,
        shuffle=True,
        num_workers=opt.num_workers)
    val_dataloader=DataLoader(val_data,opt.batch_size,
        shuffle=False,
        num_workers=opt.num_workers)
    criterion=nn.MSELoss()
    lr=opt.lr
    optimizer=torch.optim.Adam(model.parameters(),lr=lr,
        weight_decay=opt.weight_decay)

    loss_meter=meter.AverageValueMeter()
    # confusion_matrix=meter.ConfusionMeter(2)
    previous_loss=1e100

    for epoch in range(opt.max_epoch):
        loss_meter.reset()
        # confusion_matrix.reset()

        for k,(data,label) in enumerate(train_dataloader):
            # print(k)
            if opt.use_gpu:
                input=input.cuda()
                target=target.cuda()
            optimizer.zero_grad()
            score=model(input)
            loss=criterion(score,target)
            loss.backward()
            optimizer.step()

            loss_meter.add(loss.data[0])
            # confusion_matrix.add(score.data, target.data)

            if k%opt.print_freq==opt.print_freq-1:
                vis.plot('loss',loss_meter.value()[0])

            model.save()

            vak_cm,val_accuracy=val(model,val_dataloader)
            vis.plot('val_accuracy',val_accuracy)
            vis.log("epoch:{epoch},lr:{lr},loss:{loss}"
            .format(
                   epoch = epoch,
                   loss = loss_meter.value()[0],
                   lr=lr))

            if loss_meter.value()[0]>previous_loss:
                lr=lr*opt.lr_decay
                for param_group in optimizer.param_groups:
                    param_group['lr']=lr

            previous_loss=loss_meter.value()[0]

def val(model,dataloader):
    model.eval()
    confusion_matrix=meter.ConfusionMeter(2)
    for k,data in enumerate(dataloader):
        val_input,val_label = data
        
        if opt.use_gpu:
            val_input=val_input.cuda()
            val_label=val_label.cuda()
        score=model(val_input)
        confusion_matrix.add(score.data.squeeze(),val_label.long())
    model.train()
    accuracy = 100. * (cm_value[0][0] + cm_value[1][1]) /\
                (cm_value.sum())
    return confusion_matrix, accuracy

def test(**kwargs):
    opt.parse(kwargs)
    model=getattr(model,opt.model)().eval()
    if opt.load_model_path:
        model.load(opt.load_model_path)
    if opt.use_gpu: model.cuda()

    train_data=CGHData(opt.test_data_root,test=True)
    test_dataloader = DataLoader(train_data,\
        batch_size=opt.batch_size,\
        shuffle=False,\
        num_workers=opt.num_workers)
    results=[]
    for ii,(data,path) in enumerate(test_dataloader):
        input=data
        if opt.use_gpu:input=input.cuda()
        score=model(input)
        probability=F.softmax(score)[:,1].data.tolist()
        batch_results=[(path_,probability_) for path_,probability_\
        in zip(path,probability)]

        resutls+=batch_results

    return results


if __name__ == '__main__':
    import fire
    fire.Fire()