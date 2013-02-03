@interface NexusPrefsController : UIViewController
{
	BOOL wallpaper;
    float length, width, velocity, zTolerance;
    size_t count;

    UILabel * countLabel, * lengthLabel, * widthLabel, * velocityLabel, * zToleranceLabel;
    UISlider * countSlider, * lengthSlider, * widthSlider, * velocitySlider, * zToleranceSlider;
}
@property(nonatomic, retain) UIImage * image;

- (void)loadPreferences;
- (void)savePreferences;

- (void)valueChanged:(NSObject*)sender;
- (void)sliderValueChanged:(UISwitch*)sender;

@end
