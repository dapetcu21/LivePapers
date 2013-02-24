#import "LPPreview.h"
#import "LPPaper.h"
#import "LPPlugin.h"
#import "LPCommon.h"

@interface LPPaper(LPPreviewExt)
- (void)setPreview:(LPPreview*)p;
@end

@implementation LPPaper(LPPreviewExt)
- (void)setPreview:(LPPreview*)p
{
    preview = p;
}
@end

@implementation LPPreview
@synthesize viewController;
@synthesize paper;
@synthesize plugin;

- (id)initWithPaper:(LPPaper*)p
{
    if ((self = [super init]))
    {
        paper = p; 
        initInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
            paper.name, LCInitName,
            paper.bundleID, LCInitBundleID,
            [NSString stringWithFormat:@"%@/%@", LCWallpapersPath, paper.bundleID] , LCInitWallpaperPath,
            [NSString stringWithFormat:@"%@/%@.dylib", LCPluginsPath, paper.plugin], LCInitPluginPath,
            [NSNumber numberWithBool:YES], LCInitIsPreview,
            paper.userData, LCInitUserData,
            nil];

        @try {
        plugin = [[LPPlugin alloc] initWithName:paper.plugin];
        viewController = [plugin viewControllerWithUserInfo:initInfo];
        } @catch(NSException * ex)
        {
            NSLog(@"Caught exception %@", ex);
        }
    }
    return self;
}

- (UIViewController*)prefsViewController
{
    if (!triedLoadingPrefs)
    {
        triedLoadingPrefs = YES;
        @try {
        prefsViewController = [plugin preferencesViewControllerWithUserInfo:initInfo];
        } @catch(NSException * ex)
        {
            NSLog(@"Caught exception %@", ex);
        }
    }
    return prefsViewController;
}

- (BOOL)hasPreferences
{
    return [plugin hasPreferences:initInfo];
}

- (void)dealloc
{
    [initInfo release];
    [paper setPreview:nil];
    [viewController release];
    [prefsViewController release];
    [plugin release];
    [super dealloc];
}

@end
