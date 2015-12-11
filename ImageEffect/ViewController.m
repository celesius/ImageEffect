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

@interface ViewController ()

@property (nonatomic, strong) GPUImageStillCamera *stillCamera;
@property (nonatomic, strong) GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
@property (nonatomic, strong) CLRGPUImageFiler *clrFilter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _stillCamera = [[GPUImageStillCamera alloc] init];
    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
   
    GPUImageView *filteredVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, CGRectGetHeight(self.view.bounds))];
    _clrFilter = [[CLRGPUImageFiler alloc]init];
    
    _cannyEdgeFilter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
    [_stillCamera addTarget: _clrFilter];
    [_clrFilter addTarget:filteredVideoView];
    
    [_stillCamera startCameraCapture];
   
    //UIImage *img = [_cannyEdgeFilter imageFromCurrentFramebuffer];
    
    [self.view addSubview:filteredVideoView];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
