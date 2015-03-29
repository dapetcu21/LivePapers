#import "LPGLViewController.h"
#include <dlfcn.h>

@interface GLKViewController(_private)
-(CADisplayLink*)displayLink;
-(void)_createDisplayLinkForScreen:(id)screen;
@end

@interface LPGLKView : GLKView
@end
@implementation LPGLKView
-(void)setFrame:(CGRect)bounds
{
    [super setFrame:bounds];
    [(LPGLViewController*)self.delegate _reshape];
}
@end

@implementation LPGLViewController
@synthesize context = _context;
@synthesize bundle = _bundle;

-(void)_createDisplayLinkForScreen:(id)screen
{
    [super _createDisplayLinkForScreen:screen];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)loadView
{
    if (!_bundle)
        _bundle = [[NSBundle mainBundle] retain];
    GLKView * view = [[LPGLKView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    _context = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2] autorelease];

    if (!_context)
        NSLog(@"Failed to create ES context");
    
    NSLog(@"created context: %@", _context);
    [EAGLContext setCurrentContext:_context];

    self.view = view;
    view.context = _context;
    view.delegate = self;

    [self setupGL];
}

-(void)dealloc
{
    [EAGLContext setCurrentContext:_context];
    [self tearDownGL];

    [_context release];
    [_bundle release];

    [super dealloc];
}

-(void)setupGL
{
}

-(void)tearDownGL
{
}

-(void)update
{
}

-(void)render
{
}

-(void)_reshape
{
    [EAGLContext setCurrentContext:_context];
    [self reshape];
}

-(void)reshape
{
}

-(UIImage*)screenShot
{
    [EAGLContext setCurrentContext:_context];
    return ((GLKView*)self.view).snapshot;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [EAGLContext setCurrentContext:_context];
    [self render];
}


-(GLKTextureInfo*)textureNamed:(NSString*)name
{
    return [self textureFromFile:[_bundle pathForResource:name ofType:@"png"]];
}

#define texoptions [NSDictionary dictionaryWithObjectsAndKeys: \
    [NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft,\
    nil]

-(GLKTextureInfo*)textureFromFile:(NSString*)file
{
    NSError * err;
    GLKTextureInfo * i = [GLKTextureLoader textureWithContentsOfFile:file options:texoptions error:&err];
    if (!i)
        NSLog(@"Error occured while loading texture: %@", err);
    return i;
}

-(GLKTextureInfo*)textureFromUIImage:(UIImage*)img
{
    NSError * err;
    GLKTextureInfo * i = [GLKTextureLoader textureWithCGImage:img.CGImage options:texoptions error:&err];
    if (!i)
        NSLog(@"Error occured while loading texture: %@", err);
    return i;
}

-(GLuint)shaderNamed:(NSString*)name ofType:(GLenum)type
{
    NSString * ext;
    switch (type)
    {
        case GL_VERTEX_SHADER:
            ext = @"vsh";
            break;
        case GL_FRAGMENT_SHADER:
            ext = @"fsh";
            break;
        default:
            ext = @"shd";
            break;
    }
    return [self shaderFromFile:[_bundle pathForResource:name ofType:ext] ofType:type];
}

-(GLuint)shaderFromFile:(NSString*)file ofType:(GLenum)type
{
    return [self shaderFromString:[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] ofType:type];
}

-(GLuint)shaderFromString:(NSString*)str ofType:(GLenum)type;
{
    GLuint identifier = glCreateShader(type);
    const GLchar * sources[] = { [str UTF8String] };
    GLint sizes[] = { [str length] };
    glShaderSource(identifier, 1, sources, sizes);
    glCompileShader(identifier);

    GLint status;
    glGetShaderiv(identifier, GL_COMPILE_STATUS, &status);
    if (status == GL_FALSE)
    {
        GLint logLength;
        glGetShaderiv(identifier, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0)
        {
            GLchar * log = new GLchar[logLength];
            glGetShaderInfoLog(identifier, logLength, &logLength, log);
            NSLog(@"GL: Shader compile log: %s",log);
            delete [] log;
        }
        glDeleteShader(identifier);
    }
    NSAssert(status == GL_TRUE, @"GL: Shader compilation failed");
        
    return identifier;
}

-(GLuint)programNamed:(NSString*)name withBindings:(void (^)(GLuint identifer))callback
{
    return [self programWithVertexShader:
        [self shaderNamed:name ofType:GL_VERTEX_SHADER]
                          fragmentShader:
        [self shaderNamed:name ofType:GL_FRAGMENT_SHADER]
                            withBindings:callback];

}

-(GLuint)programWithVertexShader:(GLuint)vsh fragmentShader:(GLuint)fsh withBindings:(void (^)(GLuint identifer))callback;
{
    GLuint identifier = glCreateProgram();
    glAttachShader(identifier, vsh);
    glAttachShader(identifier, fsh);
    
    callback(identifier);
    
    glLinkProgram(identifier);

    glDetachShader(identifier, vsh);
    glDetachShader(identifier, fsh);

    glDeleteShader(vsh);
    glDeleteShader(fsh);
    
    GLint status;
    glGetProgramiv(identifier, GL_LINK_STATUS, &status);
    if (status == GL_FALSE)
    {
        GLint logLength;
        glGetProgramiv(identifier, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0)
        {
            GLchar * log = new GLchar[logLength];
            glGetProgramInfoLog(identifier, logLength, &logLength, log);
            NSLog(@"GL: Program link log: %s",log);
            delete [] log;
        }

        glDeleteProgram(identifier);
    }

    NSAssert(status == GL_TRUE, @"OpenGL Shader program linking failed");

    return identifier;
}

-(void)setCurrentContext
{
    [EAGLContext setCurrentContext:_context];
}

-(NSTimeInterval)adjustedTimeSinceLastUpdate
{
    NSTimeInterval r = 1.0f/self.framesPerSecond;
    NSTimeInterval t = self.timeSinceLastUpdate;
    if (t > r * 2.0f)
        t = r * 2.0f;
    return t;
}

static const NSInteger stages[] = {60, 60, 30, 30, 0};

-(void)_setFPS:(unsigned int)stage
{
    if (stage >= (sizeof(stages)/sizeof(NSInteger)))
        stage  = (sizeof(stages)/sizeof(NSInteger)) - 1;
    if (stages[stage])
    {
        self.preferredFramesPerSecond = stages[stage];
        self.paused = !_showing;
    } else {
        self.paused = YES;
    }
}

-(void)timerFired
{
    [self _setFPS:++fpsStage];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _showing = YES;
    [self resetIdleTimer];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _showing = NO;
    [idleTimer invalidate];
    idleTimer = nil;
}

static float getIdleTimeout()
{
    static void * handle = dlopen(NULL, RTLD_LAZY | RTLD_LOCAL);
    static float (*f)() = (float (*)())dlsym(handle, "LPGetIdleTimeout");
    if (f)
        return f();
    NSLog(@"Can't get idle timeout. Defaulting to 40 seconds"); 
    return 40.0f;
}

-(void)resetIdleTimer
{
    [idleTimer invalidate];
    idleTimer = [NSTimer scheduledTimerWithTimeInterval:getIdleTimeout()/((sizeof(stages)/sizeof(NSInteger)) - 1)
        target:self
        selector:@selector(timerFired)
        userInfo:nil
        repeats:YES];
    [self _setFPS:(fpsStage = 0)];
}

-(void)reloadPreferences
{
    [self resetIdleTimer];
}

@end
