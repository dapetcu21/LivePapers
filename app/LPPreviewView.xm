#import "LPPreviewView.h"
#import "LPPaper.h"
#import "LPPreview.h"
#import "LPPlugin.h"
#import <UIKit/UIStatusBar.h>

@interface UIApplication(_private)
-(UIStatusBar*)statusBar;
@end

static LPPreviewView * catchTouch = nil;

%hook UIStatusBar
-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (catchTouch)
		[catchTouch toggleFullScreen];
	else
		%orig;
}
%end

@protocol LPViewController
-(void)setWallpaperImage:(UIImage*)img;
-(void)setWallpaperRect:(CGRect)r;
-(UIImage*)screenShot;
-(void)resetIdleTimer;
@end

@implementation LPPreviewView
@synthesize fullScreenFrame;

/*UIImage * SBWallpaperGradientImageForInterfaceOrientation(int orient)
{
    return nil;
}*/

+ (void)initialize
{
	%init;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
        self.autoresizesSubviews = YES;
        timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(toWakeUpSleepingDogs) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)toWakeUpSleepingDogs
{
    if (self.hidden) return;
    UIViewController<LPViewController> * vc = (UIViewController<LPViewController>*)paper.preview.viewController;
    if (!vc) return;
    if ([vc respondsToSelector:@selector(resetIdleTimer)])
        [vc resetIdleTimer];
}

- (void)setHidden:(BOOL)h
{
    [super setHidden:h];
    if (!h)
        [self toWakeUpSleepingDogs];
}

- (void)dealloc
{
    [super dealloc];
}

UIImage * SBWallpaperImageForVariant(int);

- (void)setViewControllerImage
{
    UIViewController<LPViewController> * vc = (UIViewController<LPViewController>*)paper.preview.viewController;
    if (!vc) return;
    if ([vc respondsToSelector:@selector(setWallpaperImage:)])
    {
//        NSString * path = [NSString stringWithFormat:@"/Library/Wallpaper/%@/default.png", [UIDevice currentDevice].model];
        [vc setWallpaperImage:SBWallpaperImageForVariant(1)];
    }
}

- (void)setViewControllerFrame:(CGRect)frame
{
    [self toWakeUpSleepingDogs];
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
        
    UIImage * img;
    UIViewController<LPViewController> * vc = (UIViewController<LPViewController>*)paper.preview.viewController;
    if (vc && [vc respondsToSelector:@selector(screenShot)])
        img = [vc screenShot];
    else {
        CGRect rect = [self bounds];
        UIGraphicsBeginImageContextWithOptions(rect.size,self.opaque,0.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:context];   
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

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
    [self toWakeUpSleepingDogs];
    fullScreen = fs;
    if (fullScreen)
    {
        UIApplication * app = [UIApplication sharedApplication];
        [app setStatusBarStyle:200 animated:YES];
        [[app statusBar] _setDoubleHeightStatusString:@"Tap here to go back"];
		catchTouch = self;

        normalFrame = self.frame;
        self.userInteractionEnabled = YES;
        [self setViewControllerFrame:fullScreenFrame];
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = fullScreenFrame;
        }];
    } else {
        UIApplication * app = [UIApplication sharedApplication];
        [app setStatusBarStyle:0 animated:YES];
		catchTouch = nil;

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
