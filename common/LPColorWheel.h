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
