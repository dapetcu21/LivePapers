#import "LPView.h"
#import "LPScreenView.h"
#import "LPWallpaper.h"
#import "LPController.h"
#import "LPIntermediateVC.h"

#include <dlfcn.h>

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
    [self viewWithTag:12424].frame = b;
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
            iv.tag = 7890;
            iv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self addSubview:iv];
        }
        iv.image = img;
    } else {
        [[self viewWithTag:7890] removeFromSuperview];
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
        iv.tag = 12424;
        [self addSubview:iv];
        [iv release];
    }
    
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
        [[self viewWithTag:12424] removeFromSuperview];
        [self setWallImage: image];
        [self setWallRect:imageRect];
        [self updateScreenView];
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


@end
