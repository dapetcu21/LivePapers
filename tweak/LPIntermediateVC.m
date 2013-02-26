#import "LPIntermediateVC.h"

@protocol LPViewController
-(void)setWallpaperImage:(UIImage*)img;
-(void)setWallpaperRect:(CGRect)r;
-(void)reloadPreferences;
-(UIImage*)screenShot;
@end
@interface LPContainerView : UIView
{
    UIView * v;
}
-(id)initWithView:(UIView*)v;
@end
@implementation LPContainerView
-(id)initWithView:(UIView*)_v
{
    if ((self = [super init]))
    {
        v = _v;
        self.userInteractionEnabled = YES;
        [self addSubview:v];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    v.frame = self.bounds;
}
@end

@implementation LPIntermediateVC

-(id)initWithViewController:(UIViewController*)_vc;
{
    if ((self = [super init]))
    {
        vc = _vc;
        viewShowing = NO;
        screenLit = YES;
        [vc retain];
        if (vc)
            [self addChildViewController:vc];
    }
    return self;
}

-(void)dealloc
{
    [vc removeFromParentViewController];
    [vc release];
    [super dealloc];
}

-(BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

-(BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers
{
    return NO;
}

-(void)loadView
{
    self.view = [[[LPContainerView alloc] initWithView:vc.view] autorelease];
}

-(BOOL)screenLit
{
    return screenLit;
}

-(BOOL)viewShowing
{
    return viewShowing;
}

-(int)currentVariant
{
    return currentVariant;
}

-(BOOL)screenshotShowing
{
    return screenshotShowing;
}

#define getMask() (screenLit && viewShowing && !screenshotShowing && active[currentVariant])

-(BOOL)showingOverall
{
    return getMask();
}

-(void)setScreenLit:(BOOL)v
{
    if (v!=screenLit)
    {
        BOOL om = getMask();
        screenLit = v;
        NSLog(@"setScreenLit: %d", v);
        [self updateWithOldMask: om];
    }
}

-(void)setScreenshotShowing:(BOOL)v
{
    if (v!=screenshotShowing)
    {
        BOOL om = getMask();
        screenshotShowing = v;
        [self updateWithOldMask: om];
    }
}

-(void)setCurrentVariant:(int)var
{
    if (var!=currentVariant)
    {
        BOOL om = getMask();
        currentVariant = var;
        [self updateWithOldMask: om];
    }
}

-(void)setActive:(BOOL)a forVariant:(int)var
{
    if (active[var] == a) return;
    BOOL om = getMask();
    active[var] = a;
    NSLog(@"setActive: %d forVariant:%d", a, var);
    [self updateWithOldMask: om];
}

-(void)setViewShowing:(BOOL)v
{
    if (v!=viewShowing)
    {
        BOOL om = getMask();
        viewShowing = v;
        [self updateWithOldMask: om];
        NSLog(@"setViewShowing: %d %d", v, getMask());
    }
}

-(void)updateWithOldMask:(BOOL)m
{
    BOOL mask = getMask();
    if (mask == m) return;
    if (mask)
    {
        [vc viewWillAppear:NO];
        [vc viewDidAppear:NO];
    } else {
        [vc viewWillDisappear:NO];
        [vc viewDidDisappear:NO];
    }
}

-(void)viewWillAppear:(BOOL)b
{
    self.viewShowing = YES;
}

-(void)viewDidDisappear:(BOOL)b
{
    self.viewShowing = NO;
}

-(void)setWallpaperImage:(UIImage*)img
{
    if (vc && [vc respondsToSelector:@selector(setWallpaperImage:)])
        [(LPIntermediateVC<LPViewController>*)vc setWallpaperImage:img];
}

-(void)setWallpaperRect:(CGRect)rect
{
    if (vc && [vc respondsToSelector:@selector(setWallpaperRect:)])
        [(LPIntermediateVC<LPViewController>*)vc setWallpaperRect:rect];
}

-(void)reloadPreferences
{
    if (vc && [vc respondsToSelector:@selector(reloadPreferences)])
        [(LPIntermediateVC<LPViewController>*)vc reloadPreferences];
}

-(void)resetIdleTimer
{
    if (vc && [vc respondsToSelector:@selector(resetIdleTimer)])
        [(LPIntermediateVC<LPViewController>*)vc resetIdleTimer];
}


-(BOOL)knowsScreenShot
{
    return (vc && [vc respondsToSelector:@selector(screenShot)]);
}

-(UIImage*)screenShot
{
    if ([self knowsScreenShot])
        return [(LPIntermediateVC<LPViewController>*)vc screenShot];
    return nil;
}

@end
