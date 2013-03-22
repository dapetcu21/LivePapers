#import "LPColorPref.h"
#import "LPPrefsViewController.h"

//LPColorWheel.h

@class LPColorWheel;

@protocol LPColorWheelDelegate
    - (void)colorWheel:(LPColorWheel*)wheel changedColor:(UIColor*)color;
@end

@interface LPColorWheel : UIView 
{
    UIViewController * _rootViewController;
}

@property(nonatomic,assign) id<LPColorWheelDelegate> delegate;
@property(nonatomic,assign) UIViewController * rootViewController;

- (id)initWithRootViewController:(UIViewController*)rootViewController;
- (id)initWithFrame:(CGRect)frame;

@end

//LPRootController.h

@protocol LPRootController
    - (void)dismissPreferencesView;
    - (LPColorWheel*)newColorWheel;
@end

//--------------

@implementation LPColorPref
#define synthesize_expr(getter, setter, type, expr) \
-(type)getter { return expr; } \
-(void)setter:(type)v { expr = v; } 

#define synthesize_expr2(getter, setter, type, expr1, expr2) \
-(type)getter { return expr1; } \
-(void)setter:(type)v { expr2 = v; } 

synthesize_expr(text, setText, NSString *, label.text);
synthesize_expr(objectValue, setObjectValue, id, colorWheel.backgroundColor);

-(id)initWithController:(LPPrefsViewController*)_controller
{
    if ((self = [super init]) )
    {
        self.controller = _controller;

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

        float colorW = 75;
        LPColorWheel * vv = [(id<LPRootController>)self.controller.rootViewController newColorWheel];
        vv.frame = CGRectMake(f.size.width - 20 - colorW, 5, colorW, 40);
        vv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        vv.delegate = (id<LPColorWheelDelegate>)self;
        [v addSubview:vv];
        [vv release];
        colorWheel = vv;
    }
    return self;
}

- (void)colorWheel:(LPColorWheel*)wheel changedColor:(UIColor*)color
{
    [self.controller prefDidChange:self];
}

@end
