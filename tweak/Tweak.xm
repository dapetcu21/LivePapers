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

-(void)applicationDidFinishLaunching:(UIApplication*)app
{
    LPDisplayLinkInit();
    %orig;
    [LPController sharedInstance];
}

-(void)setBacklightFactor:(float)f keepTouchOn:(BOOL)touch
{
    static BOOL backlight = YES;
    BOOL b = (f != 0);
    if (b != backlight)
    {
        LPController * c = [LPController sharedInstance];
        [c wallpaperForVariant:0].viewController.screenLit = b;
        [c wallpaperForVariant:1].viewController.screenLit = b;
        backlight = b;
    }
    %orig;
}

-(void)resetIdleTimerAndUndim
{
    %orig;
    LPController * c = [LPController sharedInstance];
    [[c wallpaperForVariant:c.currentVariant].viewController resetIdleTimer];
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

