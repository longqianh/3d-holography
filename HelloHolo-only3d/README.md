# Hello Holo 

这是一个3D全息的计算和演示app，通过Matlab编写。



## APP说明文档

App使用方式如下。

- App主界面

  <img src="https://tva1.sinaimg.cn/large/007S8ZIlly1gjrj4mb2uuj310d0u0tuo.jpg" alt="layout" style="zoom: 50%;" />

- 导入点云数据

  主界面如下图所示，通过文件—>导入可以选择3d点云数据导入到app中。目前支持的数据格式有 `txt,xyz,ply` 三种。

  

- 选择计算波长。

  使用者需要选择全息所使用的波长，目前提供三种常用波长，分别为绿色、红色、蓝色。可根据实际情况自行修改。

  

- 旋转。

  根据需求进行对三维物体的旋转，单位为度，若角度为正则是顺时针转，反之为逆时针。前面的xyz表示旋转所绕的轴。点击还原回到开始状态。旋转之后再点击计算将进行当前旋转状态的相息图计算。

  <img src="https://tva1.sinaimg.cn/large/007S8ZIlly1gjrj6qpq79j310o0u0e81.jpg" alt="rot_res" style="zoom: 50%;" />

  

- 缩放

  改变全息计算参数中的缩放因子，可以得到不同大小物体的相息图。

<img src="https://tva1.sinaimg.cn/large/007S8ZIlly1gjrj7bs2q3j310a0u0hdt.jpg" alt="zoom_res" style="zoom: 50%;" />

- 其他初始设置

  有迭代次数、切片层数、成像距离和物体深度。通常设置迭代次数为20次，切片50层。成像距离为衍射距离，物体深度为实际物体的厚度，单位均为mm，根据实际情况确定。

- 计算。

  点击“计算”按钮后将进行相位全息图和模拟还原图的计算，有进度条提升，请耐心等待。

  <img src="https://tva1.sinaimg.cn/large/007S8ZIlly1giu4tm8bobj30us0oaq3j.jpg" alt="image-20200809174421785" style="zoom: 50%;" />



- 计算结果

  计算结果为相位全息图，下面是模拟还原图，可以直接保存。下图为一个计算示例。将相息图加载到空间光调制器（SLM）上，使用对应波长的激光进行照射，即可看到成像效果。

  
  
  
  

- 实验结果

  下图是另一张相息图旋转后照射拍摄的。

  <img src="https://tva1.sinaimg.cn/large/007S8ZIlly1ghr7ds49f4j313z0u0te9.jpg" alt="res" style="zoom: 50%;" />



- 3维旋转动态图

  <img src="./readme-graph/bunny-gif.gif" alt="image" style="zoom:67%;" />



