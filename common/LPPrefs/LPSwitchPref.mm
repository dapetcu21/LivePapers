#import "LPSwitchPref.h"
#import "LPPrefsViewController.h"

@implementation LPSwitchPref
#define synthesize_expr(getter, setter, type, expr) \
-(type)getter { return expr; } \
-(void)setter:(type)v { expr = v; } 

#define synthesize_expr2(getter, setter, type, expr1, expr2) \
-(type)getter { return expr1; } \
-(void)setter:(type)v { expr2 = v; } 

synthesize_expr(text, setText, NSString *, label.text);
synthesize_expr(intValue, setIntValue, int, sw.on);

-(id)init
{
    if ((self = [super init]) )
    {
        UIView * v = self.view;
        CGRect f = v.frame;
        f.size.height = 50;
        v.frame = f;
        
        CGRect labelFrame = CGRectMake(20, 10, f.size.width - 40, 30);
        label = [[UILabel alloc] initWithFrame: labelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [v addSubview:label];
        [label release];

        sw = [[UISwitch alloc] init];
        CGRect switchFrame = sw.frame;
        switchFrame.origin.x = f.size.width - 20 - switchFrame.size.width  + 3;
        switchFrame.origin.y = 10 + 2;
        sw.frame = switchFrame;
        sw.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [sw addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [v addSubview:sw];
        [sw release];
    }
    return self;
}

-(void)valueChanged:(UISwitch*)sender
{
    [self.controller prefDidChange:self];
}

@end
