#import "LPController.h"
#import "LPView.h"
#import "LPWallpaper.h"
#import "LPPlugin.h"
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBWallpaperView.h>

@implementation LPController
@synthesize uiController;
@synthesize wallpaperView;
@synthesize view;
@synthesize allowViewEvents;
@synthesize restrictAllow;
@synthesize allowTimeout;
@synthesize displayStacks;
@synthesize isLocking;

+(LPController*)sharedInstance
{
    static LPController * l = nil;
    if (!l)
        l = [LPController new];
    return l;
}

-(id)init
{
    if ((self = [super init]))
    {
        plugins = [[NSMutableDictionary alloc] init];
        papers = [[NSMutableDictionary alloc] init];
        displayStacks = [[NSMutableArray alloc] init];
        allowViewEvents = YES;
        allowTimeout = 0;
        restrictAllow = nil;
    }
    return self;
}

-(void)dealloc
{
    [view release];
    [lockView release];
    [plugins release];
    [displayStacks release];
    [papers release];
    [walls[0] release];
    [walls[1] release];
    [super dealloc];
}

-(LPPlugin*)pluginNamed:(NSString*)s
{
    NSValue * o = [plugins objectForKey:s];
    if (!o)
    {
        o = [NSValue valueWithNonretainedObject:[[[LPPlugin alloc] initWithName:s] autorelease]];
        [plugins setObject:o forKey:s];
    }
    return [o nonretainedObjectValue];
}

-(LPWallpaper*)wallpaperNamed:(NSString*)s
{
    NSValue * o = [papers objectForKey:s];
    if (!o)
    {
        o = [NSValue valueWithNonretainedObject:[[[LPWallpaper alloc] initWithName:s] autorelease]];
        [papers setObject:o forKey:s];
    }
    return [o nonretainedObjectValue];
}

-(void)removePluginNamed:(NSString*)s
{
    [plugins removeObjectForKey:s];
}

-(void)removeWallpaperNamed:(NSString*)s
{
    [papers removeObjectForKey:s];
}

-(LPWallpaper*)wallpaperForVariant:(int)var
{
    return walls[var];
}

-(void)setWallpaper:(LPWallpaper*)wall forVariant:(int)var
{
    [wall retain];
    [walls[var] release];
    walls[var] = wall;

    if (var == 0 && lockView)
        lockView.wallpaper = walls[0];
    if (var == 1 && view && !lockView)
        view.wallpaper = walls[1];
}

-(LPView*)lockView
{
    return lockView;
}

-(LPView*)view
{
    return view;
}

-(void)setLockView:(LPView*)v
{
    if (lockView && !v && view && walls[1] && (walls[1] == walls[0]))
    {
        if (![self appOnTop])
        {
            self.allowViewEvents = false;
            self.restrictAllow = walls[1].viewController;
            self.allowTimeout = 2;
        }
        view.wallpaper = walls[1];
    }
    lockView = v;
    if (v)
    {
        if (walls[0])
        {
            self.allowViewEvents = false;
            self.restrictAllow = walls[0].viewController;
            self.allowTimeout = 2;
        }
        if (view)
        {
            if (walls[1] == walls[0])
            {
                self.allowTimeout++;
                view.viewController = nil;
            }
            if (![self appOnTop])
            {
                UIViewController * vc = walls[1].viewController;
                [vc viewWillDisappear:NO];
                [vc viewDidDisappear:NO];
            }
        }
        v.wallpaper = walls[0];
    }
}

-(BOOL)appOnTop
{
    if (isLocking)
        return appOnTop;

    SBDisplayStack * as = (SBDisplayStack*)[displayStacks objectAtIndex:1];
    NSObject * top = [as topDisplay];
    if ([top isKindOfClass:objc_getClass("SBAwayController")])
        return ([(SBDisplayStack*)[displayStacks objectAtIndex:3] topApplication] != nil);
    return ([as topApplication] != nil);
}

-(void)setAppOnTop:(BOOL)b
{
    appOnTop = b;
}

-(BOOL)seamlessUnlock
{
    return (view && lockView && walls[0] && (walls[1] == walls[0]));
}

-(void)setView:(LPView*)v
{
    view = v;
    if (v)
        v.wallpaper = walls[1];
}

@end
