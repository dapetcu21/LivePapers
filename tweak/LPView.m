#import "LPView.h"
#import "LPWallpaper.h"
#import "LPController.h"

#include <dlfcn.h>

UIImage * (*LPWallpaperImage)(int variant);
CGRect (*LPWallpaperContentsRectForAspectFill)(CGSize, CGRect);

@protocol LPViewController
-(void)setWallpaperImage:(UIImage*)img;
-(void)setWallpaperRect:(CGRect)r;
@end

@implementation LPView
@synthesize variant;

+(void)initialize
{
    void * h = dlopen(NULL, RTLD_LAZY | RTLD_LOCAL);
    LPWallpaperImage = dlsym(h, "SBWallpaperImageForVariant");
    LPWallpaperContentsRectForAspectFill = dlsym(h, "SBWallpaperContentsRectForAspectFill");
}

-(int)orientation
{
    return orient;
}

-(void)setOrientation:(int)o
{
    [self setOrientation:o duration:0];
}

-(void)setOrientation:(int)o duration:(float)dur
{
    CGRect f = [[UIScreen mainScreen] bounds];
    if (o>2)
    {
        CGFloat a = f.size.width;
        f.size.width = f.size.height;
        f.size.height = a;
    }
    self.frame = f;
    if (vc)
        vc.view.frame = self.bounds;
    [self setWallImage: LPWallpaperImage(self.variant)];
    [self setWallRect: LPWallpaperContentsRectForAspectFill([image size], f)];
    orient = o;
}

-(void)setImage:(UIImage*)img
{
}

-(UIImage*)image
{
    CGRect rect = [self bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];   
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedImage;
}

-(CGRect)wallpaperContentsRect
{
    return CGRectMake(0, 0, 1, 1);
}

-(UIImage*)gradientImageForInterfaceOrientation:(int)orient
{
    return [[[UIImage alloc] init] autorelease];
}

-(void)setFlushWallpaperAutomatically:(BOOL)n
{
}

-(void)setPostsNotifications:(BOOL)n
{
}

-(LPWallpaper*)wallpaper
{
    return paper;
}

-(UIViewController*)viewController
{
    return vc;
}

-(void)setWallpaper:(LPWallpaper*)wp
{
    [wp retain];
    [paper release];
    paper = wp;
    self.viewController = paper.viewController;
}

-(void)setViewController:(UIViewController*)_vc
{
    if (vc)
        [vc.view removeFromSuperview];
    [_vc retain];
    [vc release];
    vc = _vc;

    if (vc)
    {
        UIView * v = vc.view;
        [v setFrame:[self bounds]];
        [self addSubview:v];
        [self setWallImage: image];
        [self setWallRect:imageRect];
    }
}

-(void)setWallImage:(UIImage*)img
{
    [img retain];
    [image release];
    image = img;
    if (vc && [vc respondsToSelector:@selector(setWallpaperImage:)])
        [(UIViewController<LPViewController>*)vc setWallpaperImage:image];
}

-(void)setWallRect:(CGRect)r
{
    imageRect = r;
    if (vc && [vc respondsToSelector:@selector(setWallpaperRect:)])
        [(UIViewController<LPViewController>*)vc setWallpaperRect:r];
}

-(id)initWithOrientation:(int)ori variant:(int)var
{
    if ((self = [super init]))
    {
        self.orientation = ori;
        self.variant = var;
    }
    return self;
}

-(void)dealloc
{
    LPController * c = [LPController sharedInstance];
    if (c.view == self)
        c.view = nil;
    if (c.lockView == self)
        c.lockView = nil;
    [vc release];
    [paper release];
    [super dealloc];
}

@end
