#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LPController.h"
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBWallpaperView.h>

#import "LPView.h"
#import "LPScreenView.h"
#import "LPIntermediateVC.h"
#import "LPWallpaper.h"

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
    if (evt.type == UIEventTypeTouches && [(UITouch*)[[evt allTouches] anyObject] phase] == UITouchPhaseBegan)
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

-(void)applicationDidFinishLaunching:(UIApplication*)app
{
    [LPController sharedInstance];
    if ([self respondsToSelector:@selector(resetIdleTimerAndUndim:)])
        %init(reset2);
    else
        %init(reset1);
    if ([self respondsToSelector:@selector(setBacklightFactor:keepTouchOn:)])
        %init(backlight2);
    else
        %init(backlight1);
    %orig;
}

%end

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
                return self = c.view = [[LPView alloc] initWithOrientation:orient variant:var];
            else
                return self = [[LPScreenView alloc] initWithMasterView:c.view];
        }
        case 0:
        {
            NSDeallocateObject(self);
            if (!c.lockView)
                return self = c.lockView = [[LPView alloc] initWithOrientation:orient variant:var];
            else
                return self = [[LPScreenView alloc] initWithMasterView:c.lockView];
        }
    }
    return %orig;
}
%end

%ctor {
    LPDisplayLinkInit();
    %init(); 
}
