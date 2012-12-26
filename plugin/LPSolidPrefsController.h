#import <UIKit/UIKit.h>

@interface LPSolidPrefsController : UIViewController
{
    CGFloat r,g,b;
    NSMutableDictionary * prefs;
}

- (void)loadPreferences;
- (void)savePreferences;
- (void)updateBg;

@end
