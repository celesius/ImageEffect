//
//  GLView.m
//  CLROpenGLES20
//
//  Created by vk on 15/11/29.
//  Copyright © 2015年 clover. All rights reserved.
//
#import "GLView.h"
#import "SHaderHelper.h"
#import <GLKit/GLKit.h>

#define TEX_COORD_MAX 4
/**
 *  There are two types of shaders:
    Vertex shaders are programs that get called once per vertex in your scene. So if you are rendering a simple scene with a single square, with one vertex at each corner, this would be called four times. Its job is to perform some calculations such as lighting, geometry transforms, etc., figure out the final position of the vertex, and also pass on some data to the fragment shader.
    Fragment shaders are programs that get called once per pixel (sort of) in your scene. So if you’re rendering that same simple scene with a single square, it will be called once for each pixel that the square covers. Fragment shaders can also perform lighting calculations, etc, but their most important job is to set the final color for the pixel.
 */

typedef struct{
    float Position[3];
    float Color[4];
    float TexCoord[2];
} Vertex;
/*
const Vertex Vertices[] = {
    {{1, -1, 0}, {1, 0, 0, 1}},
    {{1, 1, 0}, {0, 1, 0, 1}},
    {{-1, 1, 0}, {0, 0, 1, 1}},
    {{-1, -1, 0}, {0, 0, 0, 1}}
};

const GLubyte Indices[] = {
    0, 1, 2,
    2, 3, 0
};
 */
/*
const Vertex Vertices[] = {
    {{1, -1, 1}  , {1, 0, 0, 1}, {1, 0}},
    {{1, 1, 1}   , {1, 0, 0, 1}, {1, 1}},
    {{-1, 1, 1}  , {0, 1, 0, 1}, {0, 1}},
    {{-1, -1, 1} , {0, 1, 0, 1}, {0, 0}},
    {{1, -1, -1} , {1, 0, 0, 1}, {1, 0}},
    {{1, 1, -1}  , {1, 0, 0, 1}, {1, 1}},
    {{-1, 1, -1} , {0, 1, 0, 1}, {0, 1}},
    {{-1, -1, -1}, {0, 1, 0, 1}, {0, 0}}
};

const GLubyte Indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 6, 5,
    4, 7, 6,
    // Left
    2, 7, 3,
    7, 6, 2,
    // Right
    0, 4, 1,
    4, 1, 5,
    // Top
    6, 2, 1,
    1, 6, 5,
    // Bottom
    0, 3, 7,
    0, 7, 4
};
 */
const Vertex Vertices[] = {
    // Front
    {{1, -1, 0}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, 0}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, 0}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -1, 0}, {0, 0, 0, 1}, {0, 0}},
    // Back
    {{1, 1, -2}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{-1, -1, -2}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{1, -1, -2}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, 1, -2}, {0, 0, 0, 1}, {0, 0}},
    // Left
    {{-1, -1, 0}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{-1, 1, 0}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, -2}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -1, -2}, {0, 0, 0, 1}, {0, 0}},
    // Right
    {{1, -1, -2}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, -2}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{1, 1, 0}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{1, -1, 0}, {0, 0, 0, 1}, {0, 0}},
    // Top
    {{1, 1, 0}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, -2}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, -2}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, 1, 0}, {0, 0, 0, 1}, {0, 0}},
    // Bottom
    {{1, -1, -2}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, -1, 0}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, -1, 0}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -1, -2}, {0, 0, 0, 1}, {0, 0}}
};

const GLubyte Indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 5, 6,
    4, 5, 7,
    // Left
    8, 9, 10,
    10, 11, 8,
    // Right
    12, 13, 14,
    14, 15, 12,
    // Top
    16, 17, 18,
    18, 19, 16,
    // Bottom
    20, 21, 22,
    22, 23, 20
};


// 1) Add to top of file
const Vertex Vertices2[] = {
    {{0.5, -0.5, 0.01}, {1, 1, 1, 1}, {1, 1}},
    {{0.5, 0.5, 0.01}, {1, 1, 1, 1}, {1, 0}},
    {{-0.5, 0.5, 0.01}, {1, 1, 1, 1}, {0, 0}},
    {{-0.5, -0.5, 0.01}, {1, 1, 1, 1}, {0, 1}},
};

const GLubyte Indices2[] = {
    1, 0, 2, 3
};

@interface GLView () {
    GLfloat cubeAxisX;
    GLfloat cubeAxisY;
}

@property (nonatomic, assign) GLuint positionSlot;
@property (nonatomic, assign) GLuint colorSlot;
@property (nonatomic, assign) GLuint projectionUniform;
@property (nonatomic, assign) GLuint modelViewUniform;
@property (nonatomic, assign) GLKMatrix4 modelTMat;

/**
 *  texture variables
 */
@property (nonatomic, assign) GLuint floorTexture;
@property (nonatomic, assign) GLuint fishTexture;
@property (nonatomic, assign) GLuint texCoordSlot;
@property (nonatomic, assign) GLuint textureUniform;

@property (nonatomic, assign)  GLuint vertexBuffer;
@property (nonatomic, assign)  GLuint indexBuffer;
@property (nonatomic, assign)  GLuint vertexBuffer2;
@property (nonatomic, assign)  GLuint indexBuffer2;

@end

@implementation GLView
/**
 *  To set up a view to display OpenGL content, you need to set it’s default layer to a special kind of layer called a CAEAGLLayer. The way you set the default layer is to simply overwrite the layerClass method, like you just did above.
 *
 *  @return
 */
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupLayer];
        [self setupContext];
        [self setupBuffer];
        [self setupVBOs];
        [self compileShaders];
        [self setupProjection];
        [self initTransform];
        //[self render];
        _floorTexture = [self setupTexture:@"tile_floor.png"];
        _fishTexture = [self setupTexture:@"item_powerup_fish.png"];
        [self setupDisplayLink];
        //[self renderProcess];
        //[self setupDisplayLink];
        
    }
    return self;
}

- (void)setupDisplayLink {
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(renderFrame:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

/**
 * By default, CALayers are set to non-opaque (i.e. transparent). However, this is bad for performance reasons (especially with OpenGL), so it’s best to set this as opaque when possible.
 */
- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setupContext {
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}
/**
 *   setup renderbuffer
 There are three steps to create a render buffer:
 1.Call glGenRenderbuffers to create a new render buffer object. This returns a unique integer for the the render buffer (we store it here in _colorRenderBuffer). Sometimes you’ll see this unique integer referred to as an “OpenGL name.”
 2.Call glBindRenderbuffer to tell OpenGL “whenever I refer to GL_RENDERBUFFER, I really mean _colorRenderBuffer.”
 3.Finally, allocate some storage for the render buffer. The EAGLContext you created earlier has a method you can use for this called renderbufferStorage.
 
*   setup framebuffer
 The last function call (glFramebufferRenderbuffer) is new however. It lets you attach the render buffer you created earlier to the frame buffer’s GL_COLOR_ATTACHMENT0 slot.
 */
- (void)setupBuffer {

    /**
     *  depthbuffer
     */
    GLuint depthbuffer;
    glGenRenderbuffers(1, &depthbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthbuffer);
    /*
    int width, height;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    */
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
     /**
     *  renderbuffer
     */
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];   
    /**
     *  framebuffer
     */
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthbuffer);

}

- (void)setupVBOs {
    //GLuint vertexBuffer;
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_vertexBuffer2);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices2), Vertices2, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices2), Indices2, GL_STATIC_DRAW);

}

-(void)setupProjection
{
    // Generate a perspective matrix with a 60 degree FOV
    float aspect = self.frame.size.width / self.frame.size.height;
    GLKMatrix4 projectionMatrix;
    projectionMatrix = GLKMatrix4Identity;
    projectionMatrix = GLKMatrix4MakePerspective(80.0*M_PI/180, aspect, 0.5f, 2000.0f);
    // Load projection matrix
    //glUniformMatrix4fv(_projectionSlot, 1, GL_FALSE, (GLfloat*)&_projectionMatrix.m[0][0]);
    glUniformMatrix4fv(_projectionUniform, 1,GL_FALSE, &projectionMatrix.m[0]);
    //glEnable(GL_CULL_FACE);
}

- (void) initTransform{
    _modelTMat = GLKMatrix4Identity;
    _modelTMat = GLKMatrix4Translate(_modelTMat, 0, 0, -7.0);
    glUniformMatrix4fv(_modelViewUniform, 1.0, GL_FALSE, _modelTMat.m);
}

- (void) setupTransform:(CADisplayLink *)displayLink {
    _modelTMat = GLKMatrix4Identity;
    _modelTMat = GLKMatrix4Translate(_modelTMat, sin(CACurrentMediaTime()), cos(CACurrentMediaTime()), -7.0);
    static float currentRotation = 0;
    
    currentRotation += displayLink.duration*90;
    _modelTMat = GLKMatrix4Rotate(_modelTMat, currentRotation*M_PI/180, 1, 1, 0);
    
    glUniformMatrix4fv(_modelViewUniform, 1.0, GL_FALSE, _modelTMat.m);
}

- (GLuint)setupTexture:(NSString *)fileName {
    // 1
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);        
    return texName;    
}


- (void) updateColor {
    
    float rc = (sin(CACurrentMediaTime()) + 2.0) /2.0;
    /*
    const Vertex NewVertices[] = {
        {{1, -1, 0}, {rc, 0, 0, 1}},
        {{1, 1, 0}, {0, 1, 0, 1}},
        {{-1, 1, 0}, {0, 0, 1, 1}},
        {{-1, -1, 0}, {0, 0, 0, 1}}
    };
    */
    
    const Vertex NewVertices[] = {
        {{1, -1, 1},    {rc, 0, 1.0-rc, 1} , {1, 0}},
        {{1, 1, 1},     {rc, 0, 1.0-rc, 1} , {1, 1}},
        {{-1, 1, 1},    {0, 1, 0, 1}  , {0, 1}},
        {{-1, -1, 1},   {0, 1, 0, 1}  , {0, 0}},
        {{1, -1, -1},   {rc, 0, 1.0-rc, 1} , {1, 0}},
        {{1, 1, -1},    {rc, 0, 1.0-rc, 1} , {1, 1}},
        {{-1, 1, -1},   {0, 1, 0, 1}  , {0, 1}},
        {{-1, -1, -1},  {0, 1, 0, 1}  , {0, 0}}
    };                                
    
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(NewVertices), NewVertices, GL_STATIC_DRAW);
}

- (void)render:(CADisplayLink *)displayLink {
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    //[self updateColor];
    [self setupTransform:displayLink];
    
    // 1
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    // 2
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    
    
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _floorTexture);
    glUniform1i(_textureUniform, 0);
    
    // 3
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),GL_UNSIGNED_BYTE, 0);
   
    /**
     *  texture2
     */
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _fishTexture);
    glUniform1i(_textureUniform, 0);
    
   // glUniformMatrix4fv(_modelViewUniform, 1.0, GL_FALSE, _modelTMat.m); ??
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
    
    glDrawElements(GL_TRIANGLE_STRIP, sizeof(Indices2)/sizeof(Indices2[0]), GL_UNSIGNED_BYTE, 0);
    
    /**
     *  Call a method on the OpenGL context to present the render/color buffer to the UIView’s layer!
     */
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)renderByCtrl:(CADisplayLink *)displayLink{
    [self setupTransform:displayLink];
    [self renderProcess];
}

- (void)renderWall {


}


- (void)drawCube {
 
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    glEnableVertexAttribArray(_texCoordSlot);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    // 2
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    
    
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _floorTexture);
    glUniform1i(_textureUniform, 0);
    
    // 3
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),GL_UNSIGNED_BYTE, 0);
   
    /**
     *  texture2
     */
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _fishTexture);
    glUniform1i(_textureUniform, 0);
    
   // glUniformMatrix4fv(_modelViewUniform, 1.0, GL_FALSE, _modelTMat.m); ??
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
    
    glDrawElements(GL_TRIANGLE_STRIP, sizeof(Indices2)/sizeof(Indices2[0]), GL_UNSIGNED_BYTE, 0);
    glDisableVertexAttribArray(_positionSlot);
    glDisableVertexAttribArray(_colorSlot);
    glDisableVertexAttribArray(_texCoordSlot);

}
- (void)renderProcess {
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    //[self updateColor];
    //[self setupTransform:displayLink];
    // 1
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
   
    [self updateCubeTran];
    [self drawCube];
    /**
     *  Call a method on the OpenGL context to present the render/color buffer to the UIView’s layer!
     */
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)compileShaders {
    
    // 1
    GLuint vertexShader = [SHaderHelper compileShader:@"SimpleVertex"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [SHaderHelper compileShader:@"SimpleFragment"
                                       withType:GL_FRAGMENT_SHADER];
    
    // 2
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4
    glUseProgram(programHandle);
    
    // 5
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    _projectionUniform = glGetUniformLocation(programHandle, "Projection");
    _modelViewUniform = glGetUniformLocation(programHandle, "ModelView");

    _texCoordSlot = glGetAttribLocation(programHandle, "TexCoordIn");
    _textureUniform = glGetUniformLocation(programHandle, "Texture");
}

#pragma touch move
- (void) rotateAxisY:(float)axisY andAxisX:(float)axisX {

    //_modelTMat = GLKMatrix4Identity;
    //_modelTMat = GLKMatrix4Translate(_modelTMat, 0, 0, -7.0);
    //_modelTMat = GLKMatrix4Translate(_modelTMat, sin(CACurrentMediaTime()), cos(CACurrentMediaTime()), -7.0);
    //static float currentRotation = 0;
    //currentRotation += displayLink.duration*90;
    //_modelTMat = GLKMatrix4Rotate(_modelTMat, axisX*M_PI/180, axisY*M_PI/180, 1, 0);
   
    //_modelTMat = GLKMatrix4Rotate(_modelTMat, axisX*M_PI/180, 1, 0, 0);
    //_modelTMat = GLKMatrix4Rotate(_modelTMat, axisY*M_PI/180, 0, 1, 0);
    cubeAxisX = axisX;
    cubeAxisY = axisY;
}

- (void) updateCubeTran {
    GLKMatrix4 xR = GLKMatrix4MakeXRotation(cubeAxisX*M_PI/180);
    GLKMatrix4 yR = GLKMatrix4MakeYRotation(cubeAxisY*M_PI/180);
    _modelTMat = GLKMatrix4Multiply(_modelTMat, xR);
    _modelTMat = GLKMatrix4Multiply(_modelTMat, yR);
    glUniformMatrix4fv(_modelViewUniform, 1.0, GL_FALSE, _modelTMat.m);
    cubeAxisX = 0;
    cubeAxisY = 0;
}

- (void) renderFrame:(CADisplayLink *)displayLink {
    [self renderProcess];
}

@end
