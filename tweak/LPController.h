#import <SpringBoard/SBDisplayStack.h>

@class SBUIController, SBWallpaperView, LPView, LPPlugin, LPWallpaper;

@interface LPController : NSObject
{
    LPView * view;
    LPView * lockView;
    NSMutableDictionary * plugins, * papers;
    LPWallpaper * walls[2];
    BOOL allowViewEvents;
    int allowTimeout;
    UIViewController * restrictAllow;
    NSMutableArray * displayStacks;
}

@property(nonatomic, assign) SBUIController * uiController;
@property(nonatomic, assign) SBWallpaperView ** wallpaperView;
@property(nonatomic, assign) LPView * view;
@property(nonatomic, assign) LPView * lockView;
@property(nonatomic, assign) BOOL allowViewEvents;
@property(nonatomic, assign) int allowTimeout;
@property(nonatomic, assign) UIViewController * restrictAllow;
@property(nonatomic, readonly) NSMutableArray * displayStacks;
@property(nonatomic, readonly) BOOL appOnTop;

+(LPController*)sharedInstance;

-(LPPlugin*)pluginNamed:(NSString*)s;
-(LPWallpaper*)wallpaperNamed:(NSString*)s;
-(void)removePluginNamed:(NSString*)s;
-(void)removeWallpaperNamed:(NSString*)s;

-(void)setWallpaper:(LPWallpaper*)wall forVariant:(int)var;
-(LPWallpaper*)wallpaperForVariant:(int)var;

-(BOOL)seamlessUnlock;

@end
