#import "LPClassGuard.h"

@class LPColorWheel;

@protocol LPColorWheelDelegate
    - (void)colorWheel:(LPColorWheel*)wheel changedColor:(UIColor*)color;
    - (UIViewController*)rootViewController;
@end

@interface LPColorWheel : UIView 
{
}

@property(nonatomic,assign) id<LPColorWheelDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

@end
