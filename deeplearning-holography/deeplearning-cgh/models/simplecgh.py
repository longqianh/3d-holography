import torch
import torch.nn as nn


class DBlock(nn.Module):
    """docstring for DBlock
       2,2-> H/2,W/2
       
    """
    def __init__(self,in_plane,out_plane):
        super(DBlock, self).__init__()
        self.conv0=nn.Conv2d(in_plane,out_plane,kernel_size=2,stride=2) 
        self.bn1=nn.BatchNorm2d(in_plane)
        self.relu=nn.ReLU(inplace=True)
        self.conv1=nn.Conv2d(in_plane,out_plane,kernel_size=2,stride=2)
        self.bn2=nn.BatchNorm2d(out_plane)
        self.conv2=nn.Conv2d(out_plane,out_plane,kernel_size=3,stride=1,padding=1)
        

    def forward(self,x):

        out=self.bn1(x)
        out=self.relu(out)
        out=self.conv1(out)
        out=self.bn2(out)
        out=self.relu(out)
        out=self.conv2(out)
        return out+self.conv0(x)
        
class UBlock(nn.Module):

    def __init__(self,in_plane,out_plane,scale_factor=2):
        super(UBlock, self).__init__()
        self.conv0=nn.Conv2d(in_plane,out_plane,kernel_size=3,stride=1,padding=1)
        self.up0=nn.Upsample(scale_factor=scale_factor,mode='nearest') 
        self.bn1=nn.BatchNorm2d(in_plane)
        self.relu=nn.ReLU(inplace=True)
        self.up1=nn.Upsample(scale_factor=scale_factor,mode='nearest') 
        self.bn2=nn.BatchNorm2d(in_plane)
        self.conv1=nn.Conv2d(in_plane,out_plane,kernel_size=3,stride=1,padding=1)
        

    def forward(self,x):

        out=self.bn1(x)
        out=self.relu(out)
        out=self.up1(out)
        out=self.bn2(out)
        out=self.relu(out)
        out=self.conv1(out)
        return out+self.conv0(self.up0(x))
        
class RBlock(nn.Module):
    def __init__(self,in_plane,out_plane,drop=False):
        middle_plane=20
        super(RBlock, self).__init__()
        self.bn1=nn.BatchNorm2d(in_plane)
        self.relu=nn.ReLU(inplace=True)
        self.conv1=nn.Conv2d(in_plane,middle_plane,kernel_size=3,stride=1,padding=1)
        self.bn2=nn.BatchNorm2d(middle_plane)
        self.conv2=nn.Conv2d(middle_plane,out_plane,kernel_size=3,stride=1,padding=1)
        if drop==True:
            self.drop=nn.Dropout(p=0.2)
        

    def forward(self,x):

        out=self.bn1(x)
        out=self.relu(out)
        out=self.conv1(out)
        if(self.drop==True):
            out=self.drop(out)
        out=self.bn2(out)
        out=self.relu(out)
        out=self.conv2(out)
        return out+x
    
class SimpleCGH(nn.Module):
    
    def __init__(self, z_channel):
        super(SimpleCGH, self).__init__()
        self.dblock1=DBlock(z_channel,400)
        self.dblock2=DBlock(400,800)
        self.dblock3=DBlock(800,1600)
        self.ublock1=UBlock(1600,800)
        self.ublock2=UBlock(800,400)
        self.ublock3=UBlock(400,200)
        self.rblock1=RBlock(200,200,drop=True)
        self.rblock2=RBlock(200,100,drop=True)
        self.rblock3=RBlock(100,100,drop=True)
        self.rblock4=RBlock(100,z_channel,drop=True)
        self.rblock5=RBlock(z_channel,z_channel)

    def load(self,path):
        self.load_state_dict(torch.load(path))

    def save(self,name=None):
        if name is None:
            prefix = 'checkpoints/' + self.model_name + '_'
            name = time.strftime(prefix + '%m%d_%H:%M:%S.pth')
        torch.save(self.state_dict(), name)
        return name

    def forward(self,x):
        out=self.dblock1(x)
        x1=out
        out=self.dblock2(out)
        x2=out
        out=self.dblock3(out)
        x3=out
        out=self.ublock1(out+x3)
        out=self.ublock2(out+x2)
        out=self.ublock3(out+x1)
        out=self.rblock1(out)
        out=self.rblock2(out)
        out=self.rblock3(out)
        out=self.rblock4(out+x)
        out=self.rblock5(out)

        return out




if __name__ == '__main__':
        
    N=1080
    M=1920
    x=torch.randn(1,40,N,M)
    m=SimpleCGH(40)
    # if(torch.cuda.is_available()):
    #   device=torch.device('cuda:0')
    #   m.to(device)
    # print(m)
    print(m(x))
    # torch.save(m.state_dict(),'simplecgh.pth')
    # d_block=DBlock(50,400)
    # u_block=UBlock(50,400)
    # print(d_block(x))
    # print(u_block(x))