//
//  GLView.h
//  CLROpenGLES20
//
//  Created by vk on 15/11/29.
//  Copyright © 2015年 clover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface GLView : UIView

/**
 *  openGL绘图层
 */
@property (nonatomic, strong) CAEAGLLayer *eaglLayer;
/**
 *  OpenGL上下文
 */
@property (nonatomic, strong) EAGLContext *context;
/**
 *  OpenGL颜色渲染Buffer
 */
@property (nonatomic, assign) GLuint colorRenderBuffer;

- (void) rotateAxisY:(float)axisY andAxisX:(float)axisX;

@end

