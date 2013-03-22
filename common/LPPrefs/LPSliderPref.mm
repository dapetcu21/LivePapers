#import "LPSliderPref.h"
#import "LPPrefsViewController.h"

@implementation LPSliderPref
#define synthesize_expr(getter, setter, type, expr) \
-(type)getter { return expr; } \
-(void)setter:(type)v { expr = v; } 

#define synthesize_expr2(getter, setter, type, expr1, expr2) \
-(type)getter { return expr1; } \
-(void)setter:(type)v { expr2 = v; } 

@synthesize format;
synthesize_expr(text, setText, NSString *, label.text);
synthesize_expr(minimumValue, setMinimumValue, float, slider.minimumValue);
synthesize_expr(maximumValue, setMaximumValue, float, slider.maximumValue);

-(id)init
{
    if ((self = [super init]) )
    {
        self.format = @"%.2f";
        min = 0;
        max = 1;

        UIView * v = self.view;
        CGRect f = v.frame;
        f.size.height = 60;
        v.frame = f;
        
        CGRect labelFrame = CGRectMake(20, 5, f.size.width - 40, 30);
        label = [[UILabel alloc] initWithFrame: labelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [v addSubview:label];
        [label release];
     
        statusLabel = [[UILabel alloc] initWithFrame: labelFrame]; 
        statusLabel.backgroundColor = [UIColor clearColor]; 
        statusLabel.textColor = [UIColor whiteColor]; 
        statusLabel.textAlignment = NSTextAlignmentRight; 
        statusLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin; 
        [v addSubview:statusLabel]; 
        
        slider = [[UISlider alloc] initWithFrame: CGRectMake(20, 35, f.size.width - 40, 30)]; 
        slider.continuous = YES; 
        slider.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth; 
        [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged]; 
        [v addSubview:slider]; 
    }
    return self;
}

-(void)setFloatValue:(float)f
{
    slider.value = f;
    statusLabel.text = [NSString stringWithFormat:format, f];
}

-(float)floatValue
{
    return slider.value;
}

-(void)valueChanged:(UISlider*)sender
{
    statusLabel.text = [NSString stringWithFormat:format, slider.value];
    [self.controller prefDidChange:self];
}

-(void)dealloc
{
    [format release];
    [super dealloc];
}

@end
