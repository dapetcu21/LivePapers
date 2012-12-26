#import "LPSolidPrefsController.h"
#import "LPCommon.h"

@implementation LPSolidPrefsController

- (void)loadView
{
    CGRect f = [UIScreen mainScreen].bounds;
    UIView * v = [[UIView alloc] initWithFrame:f];
    self.view = v;
    [v release];

    [self loadPrefs];
}

#define test(o, c) if(!o || ![o isKindOfClass:[c class]]) o = nil

- (void)loadPreferences
{
    [prefs release];
    prefs = [[NSMutableDictionary] initWithContentsOfFile:LCBuiltinPrefsPath];
    if (!prefs)
        prefs = [[NSMutableDictionary alloc] init];

    colorArray = [prefs objectForKey:LCBuiltinPrefsSolidColor];
    test(colorArray, NSArray);
    red   = [colorArray objectAtIndex:0];
    green = [colorArray objectAtIndex:1];
    blue  = [colorArray objectAtIndex:2];
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
