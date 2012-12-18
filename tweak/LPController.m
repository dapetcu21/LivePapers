#import "LPController.h"
#import "LPView.h"
#import "LPWallpaper.h"
#import "LPPlugin.h"
#import "LPIntermediateVC.h"
#import "LPCommon.h"
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBWallpaperView.h>
#import <AppSupport/CPDistributedMessagingCenter.h>

@implementation LPController
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
        [self reloadSettings];
        Class $CPDistributedMessagingCenter = objc_getClass("CPDistributedMessagingCenter");
		center = [$CPDistributedMessagingCenter centerNamed:LCCenterName];
		[center retain];
		[center runServerOnCurrentThread];
		[center registerForMessageName:LCCenterMessageReload target:self selector:@selector(reloadSettingsWithMessage:userData:)];
    }
    return self;
}

-(void)dealloc
{
    [center release];
    [view release];
    [lockView release];
    [plugins release];
    [papers release];
    [walls[0] release];
    [walls[1] release];
    [super dealloc];
}

-(void)reloadSettingsWithMessage:(NSString*)message userData:(NSDictionary*)userData 
{
    bool loadHome = true;
    bool loadLock = true;
    if (userData && [userData isKindOfClass:[NSDictionary class]])
    {
        NSString * s = (NSString*)[userData objectForKey:LCCenterUDReloadItems];
        if ([s isEqual:LCPrefsHomeKey])
            loadLock = false;
        if ([s isEqual:LCPrefsLockKey])
            loadHome = false;
    }

    NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:LCPrefsPath];
    NSString * home = loadHome ? (NSString*)[prefs objectForKey:LCPrefsHomeKey]  : nil;
    NSString * lock = loadLock ? (NSString*)[prefs objectForKey:LCPrefsLockKey] : nil;
    if (loadHome && (!home || ![home isKindOfClass:[NSString class]]))
        home = LCDefaultPaper;
    if (loadLock && (!lock || ![lock isKindOfClass:[NSString class]]))
        lock = LCDefaultPaper;

    NSLog(@"home: %@ lock:%@ dict:%@", home, lock, userData);

    if (home)
        [self setWallpaper:nil forVariant:LPHomeScreenVariant];
    if (lock)
        [self setWallpaper:nil forVariant:LPLockScreenVariant];

    BOOL reset[2][2] = {
        { [walls[0].name isEqual:lock], [walls[0].name isEqual:home]},
        { [walls[1].name isEqual:lock], [walls[1].name isEqual:home]}
    };

    int i;
    for (i = 0; i<2; i++)
        if (reset[i][0] || reset[i][1])
            [self setWallpaper:nil forVariant:i];
    for (i = 0; i<2; i++)
    {
        if (reset[i][LPLockScreenVariant])
            [self setWallpaper:[self wallpaperNamed:lock] forVariant:i];
        else if (reset[i][LPHomeScreenVariant])
            [self setWallpaper:[self wallpaperNamed:home] forVariant:i];
    }

    if (home)
        [self setWallpaper:[self wallpaperNamed:home] forVariant:LPHomeScreenVariant];
    if (lock)
        [self setWallpaper:[self wallpaperNamed:lock] forVariant:LPLockScreenVariant];

}

-(void)reloadSettings
{
    [self reloadSettingsWithMessage:nil userData:nil];
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

-(void)setView:(LPView*)v
{
    view = v;
    if (v)
        v.wallpaper = walls[1];
}

@end
