# ImageEffect
用GPUImage实现部分视觉效果 <br />
2015.12.10 <br />
首先添加一个扫描线的视觉效果 <br />
思路：原图与边缘图合并输出，边缘图用渐变蓝色. <br />
1、用GL合并两个图层然后显示(感觉较复杂，不过可以用于静态图扫描效果) <br />
2、用GPUImage实时滤镜合并两个图层(看着较简单，感觉只能在动态图上修改) <br />

2015.12.11  <br />
1、已经利用GPUImage完成了扫描效果，效果图如下： <br />
![alt tag](https://github.com/celesius/ImageEffect/blob/master/ImageEffect/ScreenShot/ImageEffect.gif) <br />
2、后续用尝试使用OpenGL实现此效果 <br />
