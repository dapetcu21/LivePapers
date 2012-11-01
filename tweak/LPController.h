#import <SpringBoard/SBDisplayStack.h>

@class SBUIController, SBWallpaperView, LPView, LPPlugin, LPWallpaper;

#define LPStackDump() NSLog(@"%@", [NSThread callStackSymbols])

@interface LPController : NSObject
{
    LPView * view;
    LPView * lockView;
    NSMutableDictionary * plugins, * papers;
    LPWallpaper * walls[2];
}

@property(nonatomic, assign) SBUIController * uiController;
@property(nonatomic, assign) SBWallpaperView ** wallpaperView;
@property(nonatomic, assign) LPView * view;
@property(nonatomic, assign) LPView * lockView;

+(LPController*)sharedInstance;

-(LPPlugin*)pluginNamed:(NSString*)s;
-(LPWallpaper*)wallpaperNamed:(NSString*)s;
-(void)removePluginNamed:(NSString*)s;
-(void)removeWallpaperNamed:(NSString*)s;

-(void)setWallpaper:(LPWallpaper*)wall forVariant:(int)var;
-(LPWallpaper*)wallpaperForVariant:(int)var;

-(BOOL)seamlessUnlock;

@end
