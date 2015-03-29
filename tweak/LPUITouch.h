@interface UITouch (LPSynthesize)
    -(id)initFromTouch:(UITouch*)touch inView:(UIView*)view;
    -(void)syncWithTouch:(UITouch*)touch;
    -(void)changeToPhase:(UITouchPhase)phase;
    -(void)_setWindow:(UIWindow*)w;
    -(void)describe;

@property(nonatomic, assign) CGPoint locationInWindow;
@property(nonatomic, assign) CGPoint previousLocationInWindow;
@property(nonatomic, assign) int savedPhase;
@property(nonatomic, retain) id pathIndex;
@property(nonatomic, retain) id pathIdentity;
@property(nonatomic, retain) id pathMajorRadius;
@end
