#import <UIKit/UIKit.h>
#import <UIKit/UIWebBrowserView.h>

@interface LPWebKitController  : UIViewController
{
    UIWebBrowserView * webView;
    NSURL * url;
}

@property(nonatomic, retain) NSURL * url;

- (void)reloadPreferences;
@end
