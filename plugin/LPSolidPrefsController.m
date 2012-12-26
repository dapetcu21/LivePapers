#import "LPSolidPrefsController.h"
#import "LPCommon.h"

@implementation LPSolidPrefsController

- (void)loadView
{
    CGRect f = [UIScreen mainScreen].bounds;
    UIView * v = [[UIView alloc] initWithFrame:f];
    self.view = v;
    v.autoresizesSubviews = YES;
    v.userInteractionEnabled = YES;
    
    BOOL iOS5 = [UIDevice currentDevice].systemVersion.floatValue >= 5;

#define newslider(s, pos, col) \
    s = [[UISlider alloc] initWithFrame:CGRectMake(30, 30+43*pos, f.size.width - 60, 23)]; \
    s.autoresizingMask = UIViewAutoresizingFlexibleWidth; \
    [s addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged]; \
    s.minimumValue = 0; \
    s.maximumValue = 1; \
    if (iOS5) \
        s.thumbTintColor = col; \
    else \
        s.backgroundColor = col; \
    [v addSubview:s];

    newslider(rs, 0, [UIColor redColor]);
    newslider(gs, 1, [UIColor greenColor]);
    newslider(bs, 2, [UIColor blueColor]);

    [v release];
    [self loadPreferences];
    rs.value = r;
    gs.value = g;
    bs.value = b;
}

- (void)sliderValueChanged:(UISlider*)slider
{
    if (slider == rs)
        r = rs.value;
    else
    if (slider == gs)
        g = gs.value;
    else
    if (slider == bs)
        b = bs.value;
    [self updateBg];
}

#define test(o, c) if(!o || ![o isKindOfClass:[c class]]) o = nil

- (void)loadPreferences
{
    [prefs release];
    prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:LCBuiltinPrefsPath];
    if (!prefs)
        prefs = [[NSMutableDictionary alloc] init];

    NSArray * colorArray = [prefs objectForKey:LCBuiltinPrefsSolidColor];
    test(colorArray, NSArray);
    NSNumber * red   = [colorArray objectAtIndex:0];
    NSNumber * green = [colorArray objectAtIndex:1];
    NSNumber * blue  = [colorArray objectAtIndex:2];
    test(red, NSNumber);
    test(green, NSNumber);
    test(blue, NSNumber);
    if (red && green && blue)
    {
        r = red.floatValue;
        g = green.floatValue;
        b = blue.floatValue;
    } else {
        r = LCBuiltinPrefsSolidColorDefaultRed;
        g = LCBuiltinPrefsSolidColorDefaultGreen;
        b = LCBuiltinPrefsSolidColorDefaultBlue;
    }
    [self updateBg];
}

- (void)savePreferences
{
    NSArray * colorArray = [NSArray arrayWithObjects:
        [NSNumber numberWithFloat:r],
        [NSNumber numberWithFloat:g],
        [NSNumber numberWithFloat:b],
        nil];
    [prefs setObject:colorArray forKey:LCBuiltinPrefsSolidColor];
    [prefs writeToFile:LCBuiltinPrefsPath atomically:YES];
    NSLog(@"saveSettings");
}

- (void)updateBg
{
    self.view.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
}

@end
