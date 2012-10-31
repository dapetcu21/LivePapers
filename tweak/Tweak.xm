#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LPController.h"
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBWallpaperView.h>

#import "LPView.h"
#import "LPScreenView.h"
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

%hook SBUIController
-(void)lockFromSource:(int)src
{
    LPController * c = [LPController sharedInstance];
    c.appOnTop = c.appOnTop;
    c.isLocking = true;
    %orig;
    c.isLocking = false;
}
%end

%hook UIViewController 
-(void)_setViewAppearState:(int)state isAnimating:(BOOL)a
{
    LPController * c = [LPController sharedInstance];
    UIViewController * r = c.restrictAllow;
    if (c.allowViewEvents || (r && (r != self)))
    {
        %orig;
    } else {
        int t = c.allowTimeout;
        if (t)
        {
            c.allowTimeout = --t;
            if (!t)
            {
                c.allowViewEvents = true;
            }
        }
    }
}
%end

%hook SBAwayController
-(void)unlock
{
    LPController * c = [LPController sharedInstance];
    UIViewController * con = [c wallpaperForVariant:0].viewController;
    [con viewWillAppear:NO];
    %orig;
    [con viewDidAppear:NO];
}
- (void)attemptUnlockFromSource:(int)source
{
    LPController * c = [LPController sharedInstance];
    UIViewController * con = [c wallpaperForVariant:0].viewController;
    [con viewWillAppear:NO];
    [con viewDidAppear:YES];
    %orig;
}
%end

%hook SBAwayView
-(void)dealloc
{
    LPController * c = [LPController sharedInstance];
    UIViewController * con = nil;
    if (![c seamlessUnlock])
    {
        con = [c wallpaperForVariant:1].viewController;
        [con viewWillAppear:NO];
    }
    %orig;
    [con viewDidAppear:NO];
}
%end

%hook SBDisplay
-(void)handleLock:(BOOL)lock
{
    LPController * c = [LPController sharedInstance];
    if (c.appOnTop)
    {
        %orig;
        return;
    }
    UIViewController * con = [c wallpaperForVariant:0].viewController;
    [con viewWillDisappear:NO];
    %orig;
    [con viewDidDisappear:NO];
}
%end

%hook SBAlertWindow
-(void)deactivateAlert:(id)alert
{
    LPController * c;
    BOOL disable = [alert isKindOfClass:objc_getClass("SBAwayController")] && [(c = [LPController sharedInstance]) seamlessUnlock];
    if (disable)
    {
        c.allowViewEvents = c.appOnTop;
        c.allowTimeout = 0;
        c.restrictAllow = nil;
    }
    %orig;
    if (disable)
        c.allowViewEvents = true;
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

%hook SBDisplayStack
-(id)init
{
	if ((self=%orig))
	{
		[[LPController sharedInstance].displayStacks addObject:self];
	}
	return self;
}

-(void)dealloc
{
	[[LPController sharedInstance].displayStacks removeObject:self];
	%orig;
}
%end

