#import "LPController.h"
#import "LPView.h"
#import "LPWallpaper.h"
#import "LPPlugin.h"
#import "LPIntermediateVC.h"
#import "LPCommon.h"
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBWallpaperView.h>
#import <AppSupport/CPDistributedMessagingCenter.h>

__attribute__((visibility("default")))
float LPGetIdleTimeout()
{
    return [LPController sharedInstance].idleTimeout;
}

@implementation LPController
@synthesize view;
@synthesize idleTimeout;
@synthesize overlayAlpha;
@synthesize interactionHome;
@synthesize interactionLock;
@synthesize initializingFolders;

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
    [super dealloc];
}

-(void)reloadSettingsWithMessage:(NSString*)message userData:(NSDictionary*)userData 
{
    BOOL loadHome = true;
    BOOL loadLock = true;
    if (userData && [userData isKindOfClass:[NSDictionary class]])
    {
        NSString * s = (NSString*)[userData objectForKey:LCCenterUDReloadItems];
        if ([s isEqual:LCPrefsHomeKey])
            loadLock = false;
        if ([s isEqual:LCPrefsLockKey])
            loadHome = false;
    }

    NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:LCPrefsPath];
    NSNumber * nr;
    
    nr = (NSNumber*)[prefs objectForKey:LCPrefsInterHome];
    if (nr && [nr isKindOfClass:[NSNumber class]])
        self.interactionHome = nr.boolValue;
    else
        self.interactionHome = YES;

    nr = (NSNumber*)[prefs objectForKey:LCPrefsInterLock];
    if (nr && [nr isKindOfClass:[NSNumber class]])
        self.interactionLock = nr.boolValue;
    else
        self.interactionLock = YES;

    nr = (NSNumber*)[prefs objectForKey:LCPrefsOverlayAlpha];
    if (nr && [nr isKindOfClass:[NSNumber class]])
        self.overlayAlpha = nr.floatValue;
    else
        self.overlayAlpha = 1.0f;
    
    nr = (NSNumber*)[prefs objectForKey:LCPrefsIdleTimeout];
    if (nr && [nr isKindOfClass:[NSNumber class]])
        self.idleTimeout = nr.floatValue;
    else
        self.idleTimeout = 40.0f;

    
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
    
    LPWallpaper * wallHome = [self wallpaperForVariant:LPHomeScreenVariant];
    LPWallpaper * wallLock = [self wallpaperForVariant:LPLockScreenVariant];
    [wallHome reloadPreferences];
    if (wallHome != wallLock)
        [wallLock reloadPreferences];
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
}

-(void)setView:(LPView*)v
{
    view = v;
    [self setCurrentVariant:currentVariant];
}

-(void)setCurrentVariant:(int)var
{
    currentVariant = var;
    walls[0].viewController.currentVariant = currentVariant;
    walls[1].viewController.currentVariant = currentVariant;
    walls[currentVariant].viewController.interactive = currentVariant ? interactionHome : interactionLock;
    if (currentVariant == 1 && view)
        view.wallpaper = walls[1];
    if (currentVariant == 0 && lockView)
        lockView.wallpaper = walls[0];
}

-(void)setInteractionHome:(BOOL)v
{
    interactionHome = v;
    walls[1].viewController.interactive = v;
}

-(void)setInteractionLock:(BOOL)v
{
    interactionLock = v;
    walls[0].viewController.interactive = v;
}

-(int)currentVariant
{
    return currentVariant;
}

-(void)relayEvent:(UIEvent*)evt
{
    [walls[currentVariant].viewController relayEvent:evt];
}

@end
