#import <UIKit/UIKit.h>
#import "LPDefaultPrefsController.h"

@interface LPDefaultViewController : UIViewController
{
    struct LPDefaultPrefs s;
    UIImageView * imageView, * gradient;
}

- (void)reloadPreferences;

@end
