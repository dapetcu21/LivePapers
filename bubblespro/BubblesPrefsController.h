#import "BubblesCommon.h"
#import "LPColorWheel.h"

@interface BubblesPrefsController : UIViewController<LPColorWheelDelegate>
{
    BubblesSettings s;
    
    UISlider * particleCountSlider, * particleLifetimeSlider, * particleSizeSlider, * velocityMagnitudeSlider, * particleAlphaSlider, * minimumDepthSlider, * maximumDepthSlider;
    UILabel * particleCountLabel, * particleLifetimeLabel, * particleSizeLabel, * velocityMagnitudeLabel, * particleAlphaLabel, * minimumDepthLabel, * maximumDepthLabel;
    UISegmentedControl * bgTypeSegmented, * swirlSegmented, * sharpEdgesSegmented;
}
@property(nonatomic, retain) UIViewController * rootViewController;

- (id)initWithDefaults:(BubblesSettings*)def;

- (void)loadPreferences;
- (void)savePreferences;

- (void)valueChanged:(NSObject*)sender;

@end
