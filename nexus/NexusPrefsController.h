#import "LPColorWheel.h"

@interface NexusPrefsController : UIViewController<LPColorWheelDelegate>
{
	BOOL wallpaper;
    float length, width, velocity, zTolerance;
    size_t count;

    UILabel * countLabel, * lengthLabel, * widthLabel, * velocityLabel, * zToleranceLabel;
    UISlider * countSlider, * lengthSlider, * widthSlider, * velocitySlider, * zToleranceSlider;
    
    NSMutableArray * colors;
    UIViewController * rootViewController;
}
@property(nonatomic, retain) UIImage * image;
@property(nonatomic, retain) NSMutableArray * colors;
@property(nonatomic, retain) UIViewController * rootViewController;

- (void)loadPreferences;
- (void)savePreferences;

- (void)valueChanged:(NSObject*)sender;
- (void)sliderValueChanged:(UISwitch*)sender;

@end
