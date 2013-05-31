#import "LPView.h"
#import "LPScreenView.h"
#import "LPWallpaper.h"
#import "LPController.h"
#import "LPIntermediateVC.h"
#import <SpringBoard/SBAwayController.h>

#include <dlfcn.h>

extern Class SBAwayController$;

#define SCREENSHOT_TAG 12424
#define IMAGE_TAG 7890

UIImage * (*LPWallpaperImage)(int variant);
BOOL (*LPWallpaperImageIsWallpaperImage)(UIImage * img);
CGRect (*LPWallpaperContentsRectForAspectFill)(CGSize, CGRect);

@implementation LPView
@synthesize variant;
@synthesize alpha;

+(void)initialize
{
    void * h = dlopen(NULL, RTLD_LAZY | RTLD_LOCAL);
    LPWallpaperImage = dlsym(h, "SBWallpaperImageForVariant");
    LPWallpaperImageIsWallpaperImage = dlsym(h, "SBWallpaperImageIsWallpaperImage");
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
    CGRect b = self.bounds;
    if (vc)
        vc.view.frame = b;
    [self viewWithTag:SCREENSHOT_TAG].frame = b;
    [self setWallImage: LPWallpaperImage(self.variant)];
    [self setWallRect: LPWallpaperContentsRectForAspectFill([image size], f)];
    orient = o;
}


-(void)replaceWallpaperWithImage:(UIImage*)_image
{
    [self setImage:_image];
}

-(void)resetCurrentImageToWallpaper
{
    [self setImage:nil];
}

-(void)setImage:(UIImage*)img
{
    if (img && LPWallpaperImageIsWallpaperImage(img))
        img = nil;
    if (img)
    {
        UIImageView * iv = (UIImageView*)[self viewWithTag:7890];
        if (!iv)
        {
            iv = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
            iv.tag = IMAGE_TAG;
            iv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            iv.contentMode = UIViewContentModeTop;
            iv.opaque = NO;
            [self addSubview:iv];
        }
        iv.image = img;
        iv.alpha = [LPController sharedInstance].overlayAlpha;
    } else {
        [[self viewWithTag:IMAGE_TAG] removeFromSuperview];
    }
}

-(UIImage*)screenshot
{
    bool h = self.hidden;
    if (h)
        self.hidden = NO;

    UIImage * img;

    if ([vc knowsScreenShot])
        img = [vc screenShot];
    else {
        CGRect rect = [self bounds];
        UIGraphicsBeginImageContextWithOptions(rect.size,self.opaque,0.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:context];   
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    if (img)
    {
        [img retain];
        [screen release];
        screen = img;
    }

    if (h)
        self.hidden = YES;
    return screen;
}

-(void)resetScreenCount
{
    alreadyScreened = NO;
}

-(UIImage*)image
{
    if (image)
    if (vc && (vc.view.superview == self) && !alreadyScreened)
    {
        [self screenshot];
        alreadyScreened = YES;
        [self performSelector:@selector(resetScreenCount) withObject:nil afterDelay:0];
    }
    return screen;
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

-(LPIntermediateVC*)viewController
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

-(void)setViewController:(LPIntermediateVC*)_vc
{
    if (!_vc && vc)
    {
        UIImageView * iv = [[UIImageView alloc] initWithFrame:self.bounds];
        iv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        iv.image = [self screenshot];
        iv.tag = SCREENSHOT_TAG;
        [self addSubview:iv];
        [iv release];
    }
    
    if (vc)
        [vc.view removeFromSuperview];
    [_vc retain];
    [vc release];
    vc = _vc;
    _wallpaperView = nil;

    if (vc)
    {
        UIView * v = vc.view;
        _wallpaperView = v;
        [v setFrame:[self bounds]];
        [self addSubview:v];
        [[self viewWithTag:12424] removeFromSuperview];
        [self setWallImage: image];
        [self setWallRect:imageRect];
        [self updateScreenView];
        [self updateBlacknessHidden];
        [self bringSubviewToFront:_blackView];
    }
}

-(void)setWallImage:(UIImage*)img
{
    [img retain];
    [image release];
    image = img;
    [vc setWallpaperImage:image];
}

-(void)setWallRect:(CGRect)r
{
    imageRect = r;
    [vc setWallpaperRect:r];
}

-(id)initWithOrientation:(int)ori variant:(int)var
{
    if ((self = [super init]))
    {
        self.orientation = ori;
        self.variant = var;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autoresizesSubviews = YES;
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
    [screen release];
    [super dealloc];
}

-(void)updateScreenView
{
    vc.screenshotShowing = screenViews != 0;
}

-(void)updateBlacknessHidden
{
    vc.blackedOut = _blackView ? _blackView.alpha >= 1.0f : NO;
}

-(void)addScreenView
{
    screenViews++;
    [self updateScreenView];
}

-(void)removeScreenView
{
    screenViews--;
    [self updateScreenView];
}

- (void)willMoveToWindow:(UIWindow *)window
{
    LPController * c = [LPController sharedInstance];
    if (c.lockView == self)
    {
        c.currentVariant = window ? 0 : 1;
    }
}

-(void)setBlackness:(float)blackness
{
    if (!_blackView)
    {
        _blackView = [[UIView alloc] initWithFrame:self.bounds];
        _blackView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _blackView.backgroundColor = [UIColor blackColor];
        [self addSubview:_blackView];
        [_blackView release];
    }
    _blackView.alpha = blackness;
    vc.blackedOut = blackness >= 1.0f;
}

-(float)blackness
{
    if (!_blackView)
        return 0.0f;
    return _blackView.alpha;
}

-(void)setAlpha:(CGFloat)a
{
    [self setBlackness:[self shouldInterpretAlphaAsOneMinusBlackness] ? 1.0f - a : 0.0f];
}

-(CGFloat)alpha
{
    return 1.0f - [self blackness];
}

-(BOOL)shouldInterpretAlphaAsOneMinusBlackness
{
    return NO;
}

@end

@implementation LPHomescreenView
-(BOOL)shouldInterpretAlphaAsOneMinusBlackness
{
    return ![LPController sharedInstance].undimSpotlight;
}
@end

@implementation LPLockscreenView 
-(BOOL)shouldInterpretAlphaAsOneMinusBlackness
{
    if ([LPController sharedInstance].blackCharging)
        return YES;
    return [(SBAwayController*)[SBAwayController$ sharedAwayControllerIfExists] activeAwayPluginController] != nil;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return self;
}
@end
