# Hello Holo 

这是一个3D全息的计算和演示app，通过Matlab编写，2D部分和3D切片算法由国中元完成，APP的3D部分和旋转算法由黄隆钤完成。

## 文件内容

- 2d-colorful为国中元学长的2D彩色全息内容，已集成到了App-HelloHolo 文件中。
- 3d-gray大部分为国中元学长完成，我进行了代码的修改和优化，现已集成到了App-HelloHolo文件中
- App-HelloHolo文件夹为Matlab APP的文件夹，2D界面由国中元学长设计和编写，3D界面由我设计和编写
- 3d-colorful为3D彩色全息，暂时未完成





## APP说明文档

### 2D-Holography

2d操作：

点击文件-导入，导入目标图像
Mode栏选择空间划分或空间叠加法

空间划分法：
①Lambda栏左侧选中的λ，决定了用几个激光器，同时决定了划分空间的位置，两个时左右对半分，三个时各占三分之一；右侧输入激光器对应波长；
②Promote栏选中随机或球面+双相位；双相位必须配合球面使用
③Putin栏输入迭代次数、球面焦距和成像距离，一般迭代20次、球面焦距取200、成像距离800-1600
④在中下位置的“预览”是无噪声的理想效果，“调色”可通过滑动左侧颜色比例观察颜色分量变化时的模拟效果
⑤点击“计算”，计算完成后在右下角进行色差噪声分析，可保存相息图。

空间叠加法：
①Lambda栏改变三种波长，其他键无效
②直接点击“计算”



### 3D-Holography

使用方式如下。

- 导入点云数据

  主界面如下图所示，通过文件—>导入可以选择3d点云数据导入到app中。目前支持的数据格式有 `txt,xyz,ply` 三种。

  注：文件—>保存目前只支持2D全息图的保存，3D全息图的保存请直接点击大大的按钮。

<img src="https://tva1.sinaimg.cn/large/007S8ZIlly1ghkp16h56tj31290u0jty.jpg" alt="image-20200809173434383" style="zoom:80%;" />



![image-20200809174844361](https://tva1.sinaimg.cn/large/007S8ZIlly1ghkpeyrfm4j311h0u044i.jpg)

- 选择计算波长。

  目前不支持彩色3D全息的计算，因此默认选择“非彩色”模式。接下来需要选择单色全息所使用的波长，目前提供三种常用波长，分别为绿色、红色、蓝色。

- 旋转。

  根据需求进行对三维物体的旋转，单位为度，若角度为正则是顺时针转，反之为逆时针。前面的xyz表示旋转所绕的轴。点击还原回到开始状态。

- 初始设置（initial settings）。

  设置迭代次数、切片层数、成像距离和物体深度。通常设置迭代次数为20次，切片50层。成像距离和物体深度单位为mm，根据实际情况确定。

- 计算。

  点击“计算”按钮后将进行相位全息图和模拟还原图的计算，有进度条提升，请耐心等待。

  <img src="https://tva1.sinaimg.cn/large/007S8ZIlly1ghkpafwihcj30us0oaq3j.jpg" alt="image-20200809174421785" style="zoom:80%;" />



- 计算结果

  计算结果为相位全息图，下面是模拟还原图，可以直接保存。下图为一个计算示例。将相息图加载到空间光调制器（SLM）上，使用对应波长的激光进行照射，在

  ![app-1](https://tva1.sinaimg.cn/large/007S8ZIlly1ghnsla3c28j30qe0l542u.jpg)
  



- 实验结果

  下图是另一张相息图旋转后照射拍摄的。

  ![res](https://tva1.sinaimg.cn/large/007S8ZIlly1ghr7ds49f4j313z0u0te9.jpg)



- 3维旋转动态图

  ![image](./datas/bunny-gif.gif)



## 后记

关于理解全息相息图编码原理的心路历程，我写到了[这里](https://longqianh.com/2020/08/06/Physics-Holography-Road/)，欢迎大家一起探讨。



