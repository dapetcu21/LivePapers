#import <UIKit/UIKit.h>

@interface LPSolidPrefsController : UIViewController
{
    CGFloat r,g,b;
    NSMutableDictionary * prefs;
    UISlider * rs, * gs, * bs;
}

- (void)loadPreferences;
- (void)savePreferences;
- (void)updateBg;

@end
