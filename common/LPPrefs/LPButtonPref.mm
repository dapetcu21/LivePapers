#import "LPButtonPref.h"
#import "LPPrefsViewController.h"

@implementation LPButtonPref

-(id)init
{
    if ((self = [super init]) )
    {
        UIView * v = self.view;
        CGRect f = v.frame;
        f.size.height = 60;
        v.frame = f;

        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(20, 10, f.size.width - 40, 40);
        button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [button addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:button];
    }
    return self;
}

-(NSString*)text
{
    return button.currentTitle;
}

-(void)setText:(NSString*)s
{
    [button setTitle:s forState:UIControlStateNormal];
}

-(void)valueChanged:(UIButton*)sender
{
    [self.controller prefDidChange:self];
}

@end
