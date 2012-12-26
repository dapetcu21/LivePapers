#import "LPSolidViewController.h"
#import "LPCommon.h"
#include <dlfcn.h>

@implementation LPSolidViewController

-(void)loadView
{
    CGRect f = [UIScreen mainScreen].bounds;
    UIView * v = [[UIView alloc] initWithFrame:f];
    self.view = v;
    [v release];
    [self reloadPreferences];
}

#define test(o, c) if(!o || ![o isKindOfClass:[c class]]) o = nil

-(void)reloadPreferences
{
    NSLog(@"Reload");
    NSArray * colorArray;
    NSNumber * red, * green, * blue;
    CGFloat r,g,b;

    NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:LCBuiltinPrefsPath];
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
    self.view.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
}

@end
