# ImageEffect
用GPUImage实现部分视觉效果
2015.12.10
首先添加一个扫描线的视觉效果
思路：原图与边缘图合并输出，边缘图用渐变蓝色.
1、用GL合并两个图层然后显示(感觉较复杂，不过可以用于静态图扫描效果)
2、用GPUImage实时滤镜合并两个图层(看着较简单，感觉只能在动态图上修改)
![alt tag](https://github.com/celesius/ImageEffect/blob/master/ImageEffect/ScreenShot/ImageEffect.gif)
