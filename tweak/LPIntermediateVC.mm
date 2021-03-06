#import "LPIntermediateVC.h"
#import "LPUITouch.h"
#import <UIKit/UIEvent2.h>

@protocol LPViewController
-(void)setWallpaperImage:(UIImage*)img;
-(void)setWallpaperRect:(CGRect)r;
-(void)reloadPreferences;
-(UIImage*)screenShot;
-(void)setVariant:(int)v;
@end

@interface LPContainerView : UIView
{
    @public
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
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)evt
{
}
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)evt
{
}
-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)evt
{
}
-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)evt
{
}
@end

@implementation LPIntermediateVC
@synthesize savedEvent;

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
        touches = new std::map<UITouch*, UITouch*>;
    }
    return self;
}

-(void)dealloc
{
    [vc removeFromParentViewController];
    [vc release];
    for (std::map<UITouch*, UITouch*>::iterator i = touches->begin(); i != touches->end(); i++)
        [i->second release];
    delete touches;
    [savedEvent release];
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

-(BOOL)notificationCenterShowing
{
    return notifCenter;
}

-(BOOL)blackedOut
{
    return blackedOut;
}

-(void)setScreenLit:(BOOL)v
{
    if (v == screenLit) return;
    screenLit = v;
    [self updateMask];
}

-(void)setNotificationCenterShowing:(BOOL)v
{
    if (v == notifCenter) return;
    notifCenter = v;
    [self updateMask];
}

-(void)setScreenshotShowing:(BOOL)v
{
    if (v == screenshotShowing) return;
    screenshotShowing = v;
    [self updateMask];
}

-(void)setCurrentVariant:(int)var
{
    if (var == currentVariant) return;
    currentVariant = var;
    [self updateMask];
    if (vc && [vc respondsToSelector:@selector(setVariant:)])
        [(LPIntermediateVC<LPViewController>*)vc setVariant:currentVariant];
}

-(void)setActive:(BOOL)a forVariant:(int)var
{
    if (active[var] == a) return;
    active[var] = a;
    [self updateMask];
}

-(void)setViewShowing:(BOOL)v
{
    if (v == viewShowing) return;
    viewShowing = v;
    [self updateMask];
}

-(void)setBlackedOut:(BOOL)v
{
    if (v == blackedOut) return;
    blackedOut = v;
    [self updateMask];
}

#define getMask() (screenLit && !blackedOut && !notifCenter && viewShowing && !screenshotShowing && active[currentVariant])

-(BOOL)showingOverall
{
    return getMask();
}

-(void)updateMask
{
    BOOL mask = getMask();
    if (mask == oldMask) return;
    if (mask)
    {
        [vc viewWillAppear:NO];
        [vc viewDidAppear:NO];
    } else {
        [self cancelAllCurrentTouches];
        [vc viewWillDisappear:NO];
        [vc viewDidDisappear:NO];
    }
    oldMask = mask;
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

-(void)relayEvent:(UIEvent*)evt
{
    if (!getMask() || !interactive) return;
    UIView * v = ((LPContainerView*)self.view)->v;
    if (!v) return;
    
    self.savedEvent = evt;
    
    NSMutableSet * began = [NSMutableSet new];
    NSMutableSet * moved = [NSMutableSet new];
    NSMutableSet * ended = [NSMutableSet new];
    NSMutableSet * cancelled = [NSMutableSet new];
    
    for (UITouch * touch in [evt allTouches])
    {
        UITouchPhase p = touch.phase;
        if (p == UITouchPhaseBegan)
        {
            UITouch * t = [[UITouch alloc] initFromTouch:touch inView:v];
            if (t)
            {
                touches->insert(std::make_pair(touch, t));
                [began addObject:t];
            }
        }
        else
        {
            std::map<UITouch*, UITouch*>::iterator i = touches->find(touch);
            if (i != touches->end())
            {
                [i->second syncWithTouch:touch];
                switch(p)
                {
                    case UITouchPhaseMoved:
                        [moved addObject:i->second];
                        break;
                    case UITouchPhaseEnded:
                        [ended addObject:i->second];
                        [i->second release];
                        touches->erase(i);
                        break;
                    case UITouchPhaseCancelled:
                        [cancelled addObject:i->second];
                        [i->second release];
                        touches->erase(i);
                        break;
                }
            }
        }
    }
    
    if ([began count])
        [v touchesBegan:began withEvent:evt];
    if ([moved count])
        [v touchesMoved:moved withEvent:evt];
    if ([ended count])
        [v touchesEnded:ended withEvent:evt];
    if ([cancelled count])
        [v touchesCancelled:cancelled withEvent:evt];
    
    [began release];
    [moved release];
    [ended release];
    [cancelled release];
}

-(void)cancelAllCurrentTouches
{
    UIView * v = ((LPContainerView*)self.view)->v;
    if (!v) return;
    
    NSMutableSet * cancelled = [NSMutableSet new];
    for (std::map<UITouch*, UITouch*>::iterator i = touches->begin(); i != touches->end(); i++)
    {
        [i->second changeToPhase:UITouchPhaseCancelled];
        [cancelled addObject:i->second];
        [i->second release];
    }
    if ([cancelled count])
        [v touchesCancelled:cancelled withEvent:savedEvent];
    touches->clear();
    [cancelled release];
}

-(BOOL)interactive
{
    return interactive;
}

-(void)setInteractive:(BOOL)i
{
    if (interactive && !i && getMask())
        [self cancelAllCurrentTouches];
    interactive = i;
}
@end
