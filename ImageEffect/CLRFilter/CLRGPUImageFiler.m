//
//  CLRGPUImageFiler.m
//  ImageEffect
//
//  Created by vk on 15/12/10.
//  Copyright © 2015年 clover. All rights reserved.
//

#import "CLRGPUImageFiler.h"
#import "CLRTwoInputImageFilter.h"

@interface CLRGPUImageFiler()

@property (nonatomic, strong) GPUImageCannyEdgeDetectionFilter *cannyFilter;
@property (nonatomic, strong) CLRTwoInputImageFilter *clrTwoFilter;
@property (nonatomic, strong) GPUImageDilationFilter *dilationFilter;
//@property (nonatomic, strong) GPUImageFilter *clrTwoFilter;

@end

@implementation CLRGPUImageFiler

- (id)init;
{
//    if (!(self = [super initWithFragmentShaderFromString:kCLRGPUImageFilterFragmentShaderString]))
//    {
//        return nil;
//    }
    if(self = [super init]) {
        _cannyFilter = [[GPUImageCannyEdgeDetectionFilter alloc]init];
        [self addFilter:_cannyFilter];
        
        _dilationFilter = [[GPUImageDilationFilter alloc]initWithRadius:2];
        [_cannyFilter addTarget:_dilationFilter];
        
        _clrTwoFilter =  [[CLRTwoInputImageFilter alloc]init];  //[[CLRTwoInputImageFilter alloc]initWithFragmentShaderFromString:kCLRGPUImageFilterFragmentShaderString];
        [self addFilter:_clrTwoFilter];
        
        //[_cannyFilter addTarget:_clrTwoFilter atTextureLocation:1];
        [_dilationFilter addTarget:_clrTwoFilter atTextureLocation:1];
        self.initialFilters = [NSArray arrayWithObjects:_cannyFilter,_clrTwoFilter, nil];
       // self.initialFilters = [NSArray arrayWithObject:_cannyFilter];
        self.terminalFilter = _clrTwoFilter;
    
    }
    //inputDataUniform = [_clrTwoFilter->filterProgram uniformIndex:@"testDataIn"];
    //inputDataUniform = [filterProgram uniformIndex:@"testDataIn"];
    //spatialDecayUniform = [filterProgram uniformIndex:@"spatialDecay"];
    
    //[self setSpatialDecay:0.1];
    
    return self;
}

- (void)setInputData:(GLfloat)inputData {
    _inputData = inputData;
    _clrTwoFilter.inputData = _inputData;
}

- (void)setUpDown:(GLfloat)upDown {
    _upDown = upDown;
    _clrTwoFilter.updown = _upDown;
}

@end
