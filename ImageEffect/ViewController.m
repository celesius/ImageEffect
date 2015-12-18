//
//  ViewController.m
//  ImageEffect
//
//  Created by vk on 15/12/10.
//  Copyright © 2015年 clover. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage.h>
#import "CLRFilter/CLRGPUImageFiler.h"
#import <Endian.h>
#import "GLView.h"

#define clamp(a) (a>255?255:(a<0?0:a));

//#define DEBUG_CAPTURE_DISPLAY

@interface ViewController () <GPUImageVideoCameraDelegate>
{
    float moveX;
    float moveY;
    CGPoint lastTouch;
}

//@property (nonatomic, strong) GPUImageStillCamera *stillCamera;
@property (nonatomic, strong) GPUImageVideoCamera *stillCamera;
@property (nonatomic, strong) GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
@property (nonatomic, strong) CLRGPUImageFiler *clrFilter;
/**
 *  测试取得未处理图像显示用view,不需要的话可以去掉
 */
@property (nonatomic, strong) UIImageView *myView;
/**
 *  测试GL显示的View，不需要的话可以去掉
 */
@property (nonatomic, strong) GLView *glView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _stillCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    _stillCamera.delegate = self;
    //_stillCamera.frameRate = 30;
    
    GPUImageView *filteredVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, CGRectGetHeight(self.view.bounds))];
    _clrFilter = [[CLRGPUImageFiler alloc]init];
    
    _cannyEdgeFilter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
    [_stillCamera addTarget: _clrFilter];
    [_clrFilter addTarget:filteredVideoView];
    
    [_stillCamera startCameraCapture];
    [self.view addSubview:filteredVideoView];
  
#ifdef DEBUG_CAPTURE_DISPLAY
    _myView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 60, 80)];
    [self.view addSubview:_myView];
    
    _glView = [[GLView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), CGRectGetWidth(self.view.bounds)/2.0, CGRectGetHeight(self.view.bounds)/2.0)];
    [self.view addSubview:_glView];
#endif
    
    [self setupDisplayLink];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshDisp:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)refreshDisp:(CADisplayLink *)displayLink {
    static float timeLast = 0;
    float time = sin( CACurrentMediaTime() );
    time = (((time + 1.0)/2.0) * 1.5 ) - 0.5;
    if((time - timeLast) > 0.0) {
        _clrFilter.upDown = 0.6;
    }
    else {
        _clrFilter.upDown = 0.0;
    }
    timeLast = time;
    _clrFilter.inputData = time;
}

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {

    UIImage *getImage =  [[UIImage alloc]initWithCGImage:[self imageFromSampleBuffer:sampleBuffer].CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationRight];  //[self imageFromSampleBuffer:sampleBuffer];
 
    NSLog(@"%@",getImage.description);
    NSLog(@"%d",getImage.imageOrientation);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _myView.image = getImage;
    });
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    NSLog(@"vv %d ",(int)bytesPerRow );
    
   
    //CVPlanarPixelBufferInfo_YCbCrBiPlanar *bufferInfo = (CVPlanarPixelBufferInfo_YCbCrBiPlanar *)baseAddress;
    //get the cbrbuffer base address
    //uint8_t* cbrBuff = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 1);
    
    // This just moved the pointer past the offset
    baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
   
   // UIImage *image = [self makeUIImage:baseAddress bufferInfo:bufferInfo width:width height:height bytesPerRow:bytesPerRow];
   // UIImage *image = [self makeUIImage:baseAddress cBCrBuffer:cbrBuff bufferInfo:bufferInfo width:width height:height bytesPerRow:bytesPerRow];
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    NSLog(@"%d",image.imageOrientation);
    
    return (image);
}


- (UIImage *)makeUIImage:(uint8_t *)inBaseAddress bufferInfo:(CVPlanarPixelBufferInfo_YCbCrBiPlanar *)inBufferInfo width:(size_t)inWidth height:(size_t)inHeight bytesPerRow:(size_t)inBytesPerRow {
    
    NSUInteger yPitch = EndianU32_BtoN(inBufferInfo->componentInfoY.rowBytes);
    
    uint8_t *rgbBuffer = (uint8_t *)malloc(inWidth * inHeight * 4);
    uint8_t *yBuffer = (uint8_t *)inBaseAddress;
    uint8_t val;
    int bytesPerPixel = 4;
    
    // for each byte in the input buffer, fill in the output buffer with four bytes
    // the first byte is the Alpha channel, then the next three contain the same
    // value of the input buffer
    for(int y = 0; y < inHeight*inWidth; y++)
    {
        val = yBuffer[y];
        // Alpha channel
        rgbBuffer[(y*bytesPerPixel)] = 0xff;
        
        // next three bytes same as input
        rgbBuffer[(y*bytesPerPixel)+1] = rgbBuffer[(y*bytesPerPixel)+2] =  rgbBuffer[y*bytesPerPixel+3] = val;
    }
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(rgbBuffer, yPitch, inHeight, 8,
                                                 yPitch*bytesPerPixel, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    CGImageRelease(quartzImage);
    free(rgbBuffer);
    return  image;
}

- (UIImage *)makeUIImage:(uint8_t *)inBaseAddress cBCrBuffer:(uint8_t*)cbCrBuffer bufferInfo:(CVPlanarPixelBufferInfo_YCbCrBiPlanar *)inBufferInfo width:(size_t)inWidth height:(size_t)inHeight bytesPerRow:(size_t)inBytesPerRow {
    
    NSUInteger yPitch = EndianU32_BtoN(inBufferInfo->componentInfoY.rowBytes);
    NSUInteger cbCrOffset = EndianU32_BtoN(inBufferInfo->componentInfoCbCr.offset);
    uint8_t *rgbBuffer = (uint8_t *)malloc(inWidth * inHeight * 4);
    NSUInteger cbCrPitch = EndianU32_BtoN(inBufferInfo->componentInfoCbCr.rowBytes);
    uint8_t *yBuffer = (uint8_t *)inBaseAddress;
    //uint8_t *cbCrBuffer = inBaseAddress + cbCrOffset;
    uint8_t val;
    int bytesPerPixel = 4;
    
    for(int y = 0; y < inHeight; y++)
    {
        uint8_t *rgbBufferLine = &rgbBuffer[y * inWidth * bytesPerPixel];
        uint8_t *yBufferLine = &yBuffer[y * yPitch];
        uint8_t *cbCrBufferLine = &cbCrBuffer[(y >> 1) * cbCrPitch];
        
        for(int x = 0; x < inWidth; x++)
        {
            int16_t y = yBufferLine[x];
            int16_t cb = cbCrBufferLine[x & ~1] - 128;
            int16_t cr = cbCrBufferLine[x | 1] - 128;
            
            uint8_t *rgbOutput = &rgbBufferLine[x*bytesPerPixel];
            
            int16_t r = (int16_t)roundf( y + cr *  1.4 );
            int16_t g = (int16_t)roundf( y + cb * -0.343 + cr * -0.711 );
            int16_t b = (int16_t)roundf( y + cb *  1.765);
            
            //ABGR
            rgbOutput[0] = 0xff;
            rgbOutput[1] = clamp(b);
            rgbOutput[2] = clamp(g);
            rgbOutput[3] = clamp(r);
        }
    }
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSLog(@"ypitch:%lu inHeight:%zu bytesPerPixel:%d",(unsigned long)yPitch,inHeight,bytesPerPixel);
    NSLog(@"cbcrPitch:%lu",cbCrPitch);
    CGContextRef context = CGBitmapContextCreate(rgbBuffer, inWidth, inHeight, 8,
                                                 inWidth*bytesPerPixel, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    CGImageRelease(quartzImage);
    free(rgbBuffer);
    return  image;
}

#pragma touch screen
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:_glView];
    moveX = 0;
    moveY = 0;
    lastTouch = location;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:_glView];
    moveX = location.x - lastTouch.x;
    moveY = location.y - lastTouch.y;
    lastTouch = location;
    NSLog(@" XM = %f XY = %f ", moveX, moveY);
    [self.glView rotateAxisY:moveX andAxisX:moveY];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:_glView];
    moveX = location.x - lastTouch.x;
    moveY = location.y - lastTouch.y;
    lastTouch = location;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
