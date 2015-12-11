//
//  CLRTwoInputImageFilter.m
//  ImageEffect
//
//  Created by vk on 15/12/10.
//  Copyright © 2015年 clover. All rights reserved.
//

#import "CLRTwoInputImageFilter.h"

NSString *const kCLRGPUImageFilterFragmentShaderString = SHADER_STRING
(
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 varying highp vec2 textureCoordinate2;
 uniform sampler2D inputImageTexture2;
 
 uniform highp float dataIn;
 uniform highp float upDown;
 
 
 void main() {
     
     highp vec4 color1 = texture2D(inputImageTexture, textureCoordinate);
     highp vec4 color2 = texture2D(inputImageTexture2, textureCoordinate2);
     highp vec4 outColor;
     highp float alpha;
     
     if(upDown < 0.5) { //down up
         alpha = 1.0 - ((textureCoordinate.y - dataIn)/0.5);
     }
     else {
         alpha = (textureCoordinate.y - dataIn)/0.5;
     }
     
     if(color2.r != 0.0) {
         if(textureCoordinate.y > dataIn  && textureCoordinate.y < dataIn + 0.5 ){
             outColor.r = alpha + color1.r;
             outColor.g = 0.0 + color1.g;
             outColor.b = 0.0 + color1.b;
             outColor.a = 1.0;
         }else{
             outColor = color1;
         }
     } else {
         outColor = color1;
     }
     
     if(upDown < 0.5) {
         if(textureCoordinate.y > dataIn && textureCoordinate.y < dataIn + 0.01  ) {
             outColor.r = (0.0 + color1.r ) / 2.0;
             outColor.g = (1.0 + color1.g ) / 2.0;
             outColor.b = (1.0 + color1.b ) / 2.0;
             outColor.a = 0.8;
         }
     } else {
         if(textureCoordinate.y > dataIn + (0.5 - 0.01) && textureCoordinate.y < dataIn + 0.5 ){
             outColor.r = (0.0 + color1.r ) / 2.0;
             outColor.g = (1.0 + color1.g ) / 2.0;
             outColor.b = (1.0 + color1.b ) / 2.0;
             outColor.a = 0.8;
         }
     }
     
     gl_FragColor = outColor;
 }
 );

@implementation CLRTwoInputImageFilter

- (id)init
{
    if (self != [super initWithFragmentShaderFromString:kCLRGPUImageFilterFragmentShaderString ]) {
        return nil;
    }
    
    //inputDataUniform = [filterProgram ]
    inputDataUniform = [filterProgram uniformIndex:@"dataIn"];
    upDownUniform = [filterProgram uniformIndex:@"upDown"];

    return self;
}

- (void)setInputData:(GLfloat)inputData{
    _inputData = inputData;
    [self setFloat:_inputData forUniform:inputDataUniform program:filterProgram];
}

- (void)setUpdown:(GLfloat)updown {
    _updown = updown;
    [self setFloat:_updown forUniform:upDownUniform program:filterProgram];
}

@end
