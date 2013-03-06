#import <UIKit/UIKit.h>

struct LPDefaultPrefs
{
    float gradientAlpha;
};

void LPDefaultSavePrefs(struct LPDefaultPrefs * p);
void LPDefaultLoadPrefs(struct LPDefaultPrefs * p);

@interface LPDefaultPrefsController : UIViewController
{
    struct LPDefaultPrefs s;
    
    UISlider * gradientAlphaSlider;
    UILabel * gradientAlphaLabel;
}

- (void)loadPreferences;
- (void)savePreferences;
- (void)valueChanged:(NSObject*)sender;

@end
