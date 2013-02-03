#import "NexusPrefsController.h"
#import "NexusCommon.h"

@implementation NexusPrefsController
@synthesize image;

- (void)loadView
{
    CGRect f = [UIScreen mainScreen].bounds;
    UIImageView * v = [[UIImageView alloc] initWithFrame:f];
    self.view = v;
    v.autoresizesSubviews = YES;
    v.userInteractionEnabled = YES;
    v.image = self.image;
    self.image = nil;

    UILabel * label = [[UILabel alloc] initWithFrame:
        CGRectMake(30, 30, f.size.width - 60, 30)];
    label.text = @"Use my wallpaper";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [v addSubview:label];
    [label release];

    [self loadPreferences];

    UISwitch * sw = [[UISwitch alloc] initWithFrame:
        CGRectMake(f.size.width - 60 - 50, 32, 95, 27)];
    sw.on = wallpaper;
    sw.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [sw addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [v addSubview:sw];
    [sw release];

#define sliderpref(count, txt, var, minV, maxV) \
    label = [[UILabel alloc] initWithFrame: CGRectMake(30, 70 + count * 70, f.size.width - 160, 30)]; \
    label.text = txt; \
    label.backgroundColor = [UIColor clearColor]; \
    label.textColor = [UIColor whiteColor]; \
    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth; \
    [v addSubview:label]; \
    [label release]; \
    \
    var ## Label = [[UILabel alloc] initWithFrame: CGRectMake(f.size.width - 130, 70 + count * 70, 100, 30)]; \
    var ## Label.backgroundColor = [UIColor clearColor]; \
    var ## Label.textColor = [UIColor whiteColor]; \
    var ## Label.textAlignment = NSTextAlignmentRight; \
    var ## Label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin; \
    [v addSubview:var ## Label]; \
    \
    var ## Slider = [[UISlider alloc] initWithFrame: CGRectMake(30, 100 + count * 70, f.size.width - 60, 30)]; \
    var ## Slider.minimumValue = minV; \
    var ## Slider.maximumValue = maxV; \
    var ## Slider.value = var; \
    var ## Slider.continuous = YES; \
    var ## Slider.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth; \
    [var ## Slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged]; \
    [v addSubview:var ## Slider] 

    sliderpref(0, @"Strip width", width, 0.0f, 0.15f);
    sliderpref(1, @"Strip length", length, 0.0f, 1.5f);
    sliderpref(2, @"Velocity", velocity, 0.1f, 1.5f);
    sliderpref(3, @"Depth tolerance", zTolerance, 0.0f, 1.5f);
    sliderpref(4, @"Strip count", count, 1, 50);

    [self valueChanged:NULL];
    [v release];
}

- (void)sliderValueChanged:(UISwitch*)sender
{
    wallpaper = sender.on;
}

- (void)valueChanged:(NSObject*)sender
{
#define setlabel(var, format) if (sender == var ## Slider) var = var ## Slider.value; var ## Label.text = [NSString stringWithFormat:format, var]
    setlabel(width, @"%.3f");
    setlabel(length, @"%.2f");
    setlabel(velocity, @"%.2f");
    setlabel(zTolerance, @"%.2f");
    setlabel(count, @"%zu");
}

- (void)dealloc
{
    [countLabel release];
    [lengthLabel release];
    [widthLabel release];
    [velocityLabel release];
    [zToleranceLabel release];

    [countSlider release];
    [lengthSlider release];
    [widthSlider release];
    [velocitySlider release];
    [zToleranceSlider release];

    [super dealloc];
}

- (void)loadPreferences
{
    NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:NXPrefsPath];

    NSNumber * nr;
#define getparam(key, type, var, def) nr = [prefs objectForKey:key]; if([nr isKindOfClass:[NSNumber class]]) var = nr. type ## Value; else var = def
    getparam(NXWallKey,       bool, wallpaper, NO);
    getparam(NXLengthKey,     float, length, 0.6f);
    getparam(NXWidthKey,      float, width, 0.035f);
    getparam(NXVelocityKey,   float, velocity, 0.4f);
    getparam(NXZToleranceKey, float, zTolerance, 0.5f);
    getparam(NXCountKey,      int, count, 10);
}

- (void)savePreferences
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];

#define setparam(key, type, value) [dict setObject:[NSNumber numberWith ## type:value] forKey:key]
    setparam(NXWallKey,       Bool, wallpaper);
    setparam(NXLengthKey,     Float, length);
    setparam(NXWidthKey,      Float, width);
    setparam(NXVelocityKey,   Float, velocity);
    setparam(NXZToleranceKey, Float, zTolerance);
    setparam(NXCountKey,      Int, count);

    [dict writeToFile:NXPrefsPath atomically:YES];
    [dict release];
}


@end
