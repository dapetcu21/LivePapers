#import "LPSegmentPref.h"
#import "LPPrefsViewController.h"

@implementation LPSegmentPref
#define synthesize_expr(getter, setter, type, expr) \
-(type)getter { return expr; } \
-(void)setter:(type)v { expr = v; } 

#define synthesize_expr2(getter, setter, type, expr1, expr2) \
-(type)getter { return expr1; } \
-(void)setter:(type)v { expr2 = v; } 

synthesize_expr(text, setText, NSString *, label.text);
synthesize_expr(intValue, setIntValue, int, segmentedControl.selectedSegmentIndex);

-(id)initWithItems:(NSArray*)items
{
    if ((self = [super init]) )
    {
        UIView * v = self.view;
        CGRect f = v.frame;
        
        CGRect labelFrame = CGRectMake(20, 10, f.size.width - 40, 30);
        label = [[UILabel alloc] initWithFrame: labelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [v addSubview:label];
        [label release];

        segmentedControl = [[UISegmentedControl alloc] initWithItems:items]; 
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) 
        { 
            segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
            segmentedControl.tintColor = [UIColor grayColor]; 
        } 
        [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged]; 
        segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin; 
        
        CGRect r = segmentedControl.frame; 
        f.size.height = 50;
        segmentedControl.frame = CGRectMake(f.size.width - 20 - r.size.width, (f.size.height - r.size.height) * 0.5, r.size.width, r.size.height); 
        v.frame = f;

        [v addSubview:segmentedControl]; 
        [segmentedControl release];
    }
    return self;
}

-(void)valueChanged:(UISwitch*)sender
{
    [self.controller prefDidChange:self];
}

@end
