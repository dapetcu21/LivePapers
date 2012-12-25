#import "LPPreviewView.h"
#import "LPPaper.h"
#import "LPPreview.h"
#import "LPPlugin.h"

@protocol LPViewController
-(void)setWallpaperImage:(UIImage*)img;
-(void)setWallpaperRect:(CGRect)r;
@end

@implementation LPPreviewView
@synthesize fullScreenFrame;

UIImage * SBWallpaperGradientImageForInterfaceOrientation(int orient)
{
    return nil;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
        self.autoresizesSubviews = YES;
    }
    return self;
}

- (void)setViewControllerImage
{
    UIViewController<LPViewController> * vc = (UIViewController<LPViewController>*)paper.preview.viewController;
    if (!vc) return;
    if ([vc respondsToSelector:@selector(setWallpaperImage:)])
    {
        NSString * path = [NSString stringWithFormat:@"/Library/Wallpaper/%@/default.png", [UIDevice currentDevice].model];
        [vc setWallpaperImage:[UIImage imageWithContentsOfFile:path]];
    }
}

- (void)setViewControllerFrame:(CGRect)frame
{
    UIViewController<LPViewController> * vc = (UIViewController<LPViewController>*)paper.preview.viewController;
    if (!vc) return;
    if (view && [vc respondsToSelector:@selector(setWallpaperRect:)])
    {
        CGFloat ar = frame.size.width / frame.size.height;
        CGRect r;
        if (ar < 1)
        {
            r.size.width = ar;
            r.size.height = 1;
            r.origin.x = (1-ar)/2;
            r.origin.y = 0;
        } else {
            r.size.width = 1;
            r.size.height = ar;
            r.origin.x = 0;
            r.origin.y = (1-ar)/2;
        }
        [vc setWallpaperRect:r];
    }
}

- (void)setViewControllerParams
{
    [self setViewControllerImage];
    [self setViewControllerFrame:view.frame];
}

- (void)setPaper:(LPPaper*)p
{
    if (paper == p) return;
    [p retain];
    [p.preview retain];
    [view removeFromSuperview];
    [paper.preview release];
    [paper release];
    paper = p;
    view = paper.preview.viewController.view;
    if (view)
        [self addSubview:view];
    view.frame = self.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self setViewControllerParams];
}

- (LPPaper*)paper
{
    return paper;
}

- (UIImage*)screenShot
{
    bool h = self.hidden;
    if (h)
        self.hidden = NO;

    CGRect rect = [self bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,self.opaque,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];   
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (h)
        self.hidden = YES;
    return img;
}

- (BOOL)fullScreen
{
    return fullScreen;
}

- (void)toggleFullScreen
{
    self.fullScreen = !self.fullScreen;
}

- (void)setFullScreen:(BOOL)fs
{
    if (fs == fullScreen) return;
    fullScreen = fs;
    if (fullScreen)
    {
        normalFrame = self.frame;
        self.userInteractionEnabled = YES;
        [self setViewControllerFrame:fullScreenFrame];
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = fullScreenFrame;
        }];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = normalFrame;
        } completion:^(BOOL animated){
            self.userInteractionEnabled = NO;
            [self setViewControllerFrame:normalFrame];
        }];
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (((UITouch*)[touches anyObject]).tapCount == 1)
        [self toggleFullScreen];
}

@end
