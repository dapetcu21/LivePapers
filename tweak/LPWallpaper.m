#import "LPWallpaper.h"
#import "LPPlugin.h"
#import "LPController.h"
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

-(UIViewController*)viewController
{
    if (!vc)
    {
        @try {
            NSDictionary * info = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/Library/LivePapers/Wallpapers/%@/Info.plist", name]];
            NSString * pluginName = [NSString stringWithString:[info objectForKey:@"Plugin"]];
            NSObject * ud = [info objectForKey:@"User Data"];
            plugin = [[[LPController sharedInstance] pluginNamed:pluginName] retain];
            vc = [plugin newViewController:ud];
        }
        @catch(NSException * ex) {
            NSLog(@"LivePapers: Cannot load wallpaper %@: %@", name, ex);
        }
    }
    return vc;
}

@end
