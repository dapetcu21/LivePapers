#ifndef LPGLVIEWCONTROLLER_H
#define LPGLVIEWCONTROLLER_H

#import <GLKit/GLKit.h>

@interface LPGLViewController : GLKViewController
{
    EAGLContext * _context;
    NSBundle * _bundle;
    BOOL snap;

    NSTimer * idleTimer;
    unsigned int fpsStage;
    BOOL _showing;
}
@property (nonatomic, readonly) EAGLContext * context;
@property (nonatomic, retain) NSBundle * bundle;
@property (nonatomic, readonly) NSTimeInterval adjustedTimeSinceLastUpdate;


//to override
-(void)setupGL;
-(void)tearDownGL;
-(void)update;
-(void)render;
-(void)reshape;

-(GLKTextureInfo*)textureNamed:(NSString*)name;
-(GLKTextureInfo*)textureFromFile:(NSString*)file;
-(GLKTextureInfo*)textureFromUIImage:(UIImage*)img;

-(GLuint)shaderNamed:(NSString*)name ofType:(GLenum)type;
-(GLuint)shaderFromFile:(NSString*)file ofType:(GLenum)type;
-(GLuint)shaderFromString:(NSString*)string ofType:(GLenum)type;
-(GLuint)programNamed:(NSString*)name withBindings:(void (^)(GLuint identifer))callback;
-(GLuint)programWithVertexShader:(GLuint)vsh fragmentShader:(GLuint)fsh withBindings:(void (^)(GLuint identifer))callback;

-(void)setCurrentContext;
-(void)resetIdleTimer;

@end

#endif
