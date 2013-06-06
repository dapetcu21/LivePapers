@interface UITouch (LPSynthesize)
    -(id)initFromTouch:(UITouch*)touch inView:(UIView*)view;
    -(void)syncWithTouch:(UITouch*)touch;
    -(void)changeToPhase:(UITouchPhase)phase;
    -(void)_setWindow:(UIWindow*)w;
    -(void)describe;
@end
