@class LPView, LPPlugin, LPWallpaper, CPDistributedMessagingCenter;

#define LPStackDump() NSLog(@"%@", [NSThread callStackSymbols])
#define LPLockScreenVariant 0
#define LPHomeScreenVariant 1

@interface LPController : NSObject
{
    LPView * view;
    LPView * lockView;
    NSMutableDictionary * plugins, * papers;
    LPWallpaper * walls[2];
    CPDistributedMessagingCenter * center;

    int currentVariant;
}

@property(nonatomic, assign) LPView * view;
@property(nonatomic, assign) LPView * lockView;
@property(nonatomic, assign) int currentVariant;

+(LPController*)sharedInstance;

-(LPPlugin*)pluginNamed:(NSString*)s;
-(LPWallpaper*)wallpaperNamed:(NSString*)s;
-(void)removePluginNamed:(NSString*)s;
-(void)removeWallpaperNamed:(NSString*)s;

-(void)setWallpaper:(LPWallpaper*)wall forVariant:(int)var;
-(LPWallpaper*)wallpaperForVariant:(int)var;

-(void)reloadSettings;
-(void)reloadSettingsWithMessage:(NSString*)message userData:(NSDictionary*)userData;

-(void)relayEvent:(UIEvent*)evt;

@end
