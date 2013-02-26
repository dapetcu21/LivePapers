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

static LPController * LPControllerSharedInstance = nil;

+(LPController*)sharedInstance
{
    if (!LPControllerSharedInstance)
        LPControllerSharedInstance = [LPController new];
    return LPControllerSharedInstance;
}

-(id)init
{
    if ((self = [super init]))
    {
        LPControllerSharedInstance = self;
        plugins = [[NSMutableDictionary alloc] init];
        papers = [[NSMutableDictionary alloc] init];
        touches = [[NSMutableSet alloc] init];
        [self reloadSettings];
        Class $CPDistributedMessagingCenter = objc_getClass("CPDistributedMessagingCenter");
		center = [$CPDistributedMessagingCenter centerNamed:LCCenterName];
		[center retain];
		[center runServerOnCurrentThread];
		[center registerForMessageName:LCCenterMessageReload target:self selector:@selector(reloadSettingsWithMessage:userData:)];
		[center registerForMessageName:LCCenterMessagePrefs target:self selector:@selector(reloadPreferencesWithMessage:userData:)];
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
    [touches release];
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

    if (home)
        [self setWallpaper:[self wallpaperNamed:home] forVariant:LPHomeScreenVariant];
    if (lock)
        [self setWallpaper:[self wallpaperNamed:lock] forVariant:LPLockScreenVariant];
}

-(void)reloadPreferencesWithMessage:(NSString*)message userData:(NSDictionary*)userData 
{
    LPWallpaper * wall = nil;
    if (userData && [userData isKindOfClass:[NSDictionary class]])
    {
        NSString * s = (NSString*)[userData objectForKey:LCCenterUDPrefsItems];
        LPWallpaper * w = [self wallpaperForVariant:LPHomeScreenVariant];
        if ([s isEqual:w.name])
            wall = w;
        w = [self wallpaperForVariant:LPLockScreenVariant];
        if ([s isEqual:w.name])
            wall = w;
    }

    [wall reloadPreferences];
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
    if (wall != walls[var])
    {
        [wall.viewController setActive:YES forVariant:var];
        [walls[var].viewController setActive:NO forVariant:var];
    }

    [wall retain];
    [walls[var] release];
    walls[var] = wall;

    if (var == 0 && lockView)
        lockView.wallpaper = walls[0];
    if (var == 1 && view && !lockView)
        view.wallpaper = walls[1];
    
    [self setCurrentVariant:currentVariant];
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
    lockView = v;
    [self setCurrentVariant:currentVariant];
    //NSLog(@"setlockview: %@", v);
    return;
    currentVariant = v ? 0 : 1;
    walls[0].viewController.currentVariant = currentVariant;
    walls[1].viewController.currentVariant = currentVariant;

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
    //NSLog(@"setview: %@", v);
    view = v;
    [self setCurrentVariant:currentVariant];
}

-(void)setCurrentVariant:(int)var
{
    currentVariant = var;
    walls[0].viewController.currentVariant = currentVariant;
    walls[1].viewController.currentVariant = currentVariant;
    if (currentVariant == 1 && view)
        view.wallpaper = walls[1];
    if (currentVariant == 0 && lockView)
        lockView.wallpaper = walls[0];
}

-(int)currentVariant
{
    return currentVariant;
}

-(void)relayEvent:(UIEvent*)evt
{
    
}

-(void)beginAllTouches
{
    NSLog(@"begin all touches");
}

-(void)cancelAllTouches
{
    NSLog(@"cancel all touches");
}

@end
