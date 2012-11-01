#import "LPController.h"
#import "LPView.h"
#import "LPWallpaper.h"
#import "LPPlugin.h"
#import "LPIntermediateVC.h"
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBWallpaperView.h>

@implementation LPController
@synthesize uiController;
@synthesize wallpaperView;
@synthesize view;

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
    }
    return self;
}

-(void)dealloc
{
    [view release];
    [lockView release];
    [plugins release];
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
        view.wallpaper = walls[1];
    lockView = v;
    if (v)
    {
        if (view && (walls[1] == walls[0]))
            view.viewController = nil;
        v.wallpaper = walls[0];
    }
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
