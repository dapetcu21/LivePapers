#import "LPRootViewController.h"
#import "LPNotifications.h"

void LPDisplayLinkInit();

@interface LivePapersApplication: UIApplication <UIApplicationDelegate> {
	UIWindow *_window;
	LPRootViewController *_viewController;
}
@property (nonatomic, retain) UIWindow *window;
@end

@implementation LivePapersApplication
@synthesize window = _window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
#if !TARGET_IPHONE_SIMULATOR
	LPDisplayLinkInit();
#endif
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_viewController = [[LPRootViewController alloc] init];
    [_window setRootViewController:_viewController];
	[_window makeKeyAndVisible];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    LPListenForNotifications();
}

- (void)dealloc {
	[_viewController release];
	[_window release];
	[super dealloc];
}
@end

// vim:ft=objc
