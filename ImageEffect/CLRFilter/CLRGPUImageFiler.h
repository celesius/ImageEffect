//
//  CLRGPUImageFiler.h
//  ImageEffect
//
//  Created by vk on 15/12/10.
//  Copyright © 2015年 clover. All rights reserved.
//

#import <GPUImage.h>

@interface CLRGPUImageFiler : GPUImageFilterGroup//GPUImageTwoInputFilter

@property (nonatomic, assign) GLfloat inputData;

@property (nonatomic, assign) GLfloat upDown;

@end
