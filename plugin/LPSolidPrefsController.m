#import "LPSolidPrefsController.h"
#import "LPCommon.h"

@implementation LPSolidPrefsController

- (void)loadView
{
    CGRect f = [UIScreen mainScreen].bounds;
    UIView * v = [[UIView alloc] initWithFrame:f];
    v.backgroundColor = [UIColor redColor];
    self.view = v;
    [v release];
}

- (void)savePreferences
{
    NSLog(@"saveSettings");
}

@end
