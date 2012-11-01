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

-(void)applicationDidFinishLaunching:(UIApplication*)app
{
    %orig;
    LPController * c = [LPController sharedInstance];
    [c setWallpaper:[c wallpaperNamed:@"com.dapetcu21.livepapers.default"] forVariant:0];
    [c setWallpaper:[c wallpaperNamed:@"com.dapetcu21.livepapers.default"] forVariant:1];
}

%end

%hook SpringBoard
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

