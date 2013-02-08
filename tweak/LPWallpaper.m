#import "LPWallpaper.h"
#import "LPPlugin.h"
#import "LPController.h"
#import "LPIntermediateVC.h"
#import "LPCommon.h"
#import <UIKit/UIKit.h>

@implementation LPWallpaper
@synthesize name;

-(id)initWithName:(NSString*)s
{
    if ((self = [super init])) 
    {
        name = [s retain];
    }
    return self;
}

-(void)dealloc
{
    [vc release];
    [plugin release];
    [[LPController sharedInstance] removeWallpaperNamed:name];
    [name release];
    [super dealloc];
}

-(LPIntermediateVC*)viewController
{
    if (!vc)
    {
        @try {
            NSDictionary * info = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/Info.plist", LCWallpapersPath, name]];
            NSString * pluginName = [NSString stringWithString:[info objectForKey:@"Plugin"]];
            NSObject * ud = [info objectForKey:@"User Data"];
            NSString * displayName = [info objectForKey:@"Name"];
            NSString * path = [NSString stringWithFormat:@"%@/%@", LCWallpapersPath, name];
            NSDictionary * initInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                displayName, LCInitName,
                name, LCInitBundleID,
                path, LCInitWallpaperPath,
                [NSString stringWithFormat:@"%@/%@.dylib", LCPluginsPath, pluginName], LCInitPluginPath,
                [NSNumber numberWithBool:NO], LCInitIsPreview,
                ud, LCInitUserData,
                nil];

            plugin = [[[LPController sharedInstance] pluginNamed:pluginName] retain];
            UIViewController * v = [plugin newViewController:initInfo];
            vc = [[LPIntermediateVC alloc] initWithViewController:v];
            [v release];
        }
        @catch(NSException * ex) {
            NSLog(@"LivePapers: Cannot load wallpaper %@: %@", name, ex);
            if (plugin)
            {
                [plugin release];
                plugin = nil;
            }
        }
    }
    return vc;
}

-(void)reloadPreferences
{
    [self.viewController reloadPreferences];
}

@end
