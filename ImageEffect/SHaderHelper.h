//
//  SHaderHelper.h
//  CLROpenGLES20
//
//  Created by vk on 15/11/29.
//  Copyright © 2015年 clover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface SHaderHelper : NSObject

+ (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType;

@end
