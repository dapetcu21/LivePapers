#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LPController.h"
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBWallpaperView.h>
#import <SpringBoard/SBAwayController.h>
#import <objc/runtime.h>

#import "LPView.h"
#import "LPScreenView.h"
#import "LPIntermediateVC.h"
#import "LPWallpaper.h"

Class SpringBoard$;

%hook SpringBoard 

extern "C" void LPDisplayLinkInit();

static void resetIdle()
{
    LPController * c = [LPController sharedInstance];
    [[c wallpaperForVariant:c.currentVariant].viewController resetIdleTimer];
}

static void setBacklight(float f)
{
    static BOOL backlight = YES;
    BOOL b = (f != 0);
    if (b != backlight)
    {
        LPController * c = [LPController sharedInstance];
        [c wallpaperForVariant:0].viewController.screenLit = b;
        [c wallpaperForVariant:1].viewController.screenLit = b;
        backlight = b;
        resetIdle();
    }
}

%group backlight1
-(void)setBacklightFactor:(float)f
{
    setBacklight(f);
    %orig;
}
%end

%group backlight2
-(void)setBacklightFactor:(float)f keepTouchOn:(BOOL)touch
{
    setBacklight(f);
    %orig;
}
%end

%group reset1
-(void)resetIdleTimerAndUndim
{
    %orig;
    resetIdle();
}
%end

%group reset2
-(void)resetIdleTimerAndUndim:(BOOL)undim
{
    %orig;
    resetIdle();
}
%end

-(void)menuButtonDown:(GSEventRef)down
{
    %orig;
    resetIdle(); 
}

-(void)sendEvent:(UIEvent*)evt
{
    %orig;
    if (evt.type == UIEventTypeTouches)
    {
        LPController * c = [LPController sharedInstance];
        [c relayEvent:evt];
        if ([(UITouch*)[[evt allTouches] anyObject] phase] == UITouchPhaseBegan)
        {
            BOOL doit = NO;
            NSSet * set = [evt allTouches]; 
            for (UITouch * e in set)
                if (e.phase == UITouchPhaseBegan)
                {
                    doit = YES;
                    break;
                }
            if (doit)
                resetIdle();
        }
    }
}

%end

@interface LPHomescreenView : LPView {}
@end
@implementation LPHomescreenView
@end
@interface LPLockscreenView : LPView {}
@end
@implementation LPLockscreenView 

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return self;
}

@end

%hook SBWallpaperView
-(id)initWithOrientation:(int)orient variant:(int)var
{
    LPController * c = [LPController sharedInstance];
    switch(var)
    {
        case 1:
        {
            NSDeallocateObject(self);
            if (!c.view)
                return self = c.view = [[LPHomescreenView alloc] initWithOrientation:orient variant:var];
            else
                return self = [[LPScreenView alloc] initWithMasterView:c.view];
        }
        case 0:
        {
            NSDeallocateObject(self);
            if (!c.lockView)
                return self = c.lockView = [[LPLockscreenView alloc] initWithOrientation:orient variant:var];
            else
                return self = [[LPScreenView alloc] initWithMasterView:c.lockView];
        }
    }
    return %orig;
}
%end

%ctor {
    SpringBoard$ = objc_getClass("SpringBoard");

    LPDisplayLinkInit();
    %init(); 

    if ([SpringBoard$ instancesRespondToSelector:@selector(resetIdleTimerAndUndim:)])
        %init(reset2);
    else
        %init(reset1);
    
    if ([SpringBoard$ instancesRespondToSelector:@selector(setBacklightFactor:keepTouchOn:)])
        %init(backlight2);
    else
        %init(backlight1);
}
