#import "LPPreview.h"
#import "LPPaper.h"
#import "LPPlugin.h"

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
        @try {
        plugin = [[LPPlugin alloc] initWithName:paper.plugin];
        viewController = [plugin viewControllerWithUserInfo:paper.userData];
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
        prefsViewController = [plugin preferencesViewControllerWithUserInfo:paper.userData];
        } @catch(NSException * ex)
        {
            NSLog(@"Caught exception %@", ex);
        }
    }
    return prefsViewController;
}

- (void)dealloc
{
    [paper setPreview:nil];
    [viewController release];
    [prefsViewController release];
    [plugin release];
    [super dealloc];
}

@end
