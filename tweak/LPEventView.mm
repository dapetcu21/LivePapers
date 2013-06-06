#import "LPEventView.h"
#import "LPUITouch.h"

@implementation LPEventView

-(id)initWithFrame:(CGRect)r
{
    if ((self = [super initWithFrame:r]))
    {
        self.windowLevel = -100;
        self.hidden = NO;
    }
    return self;
}

-(void)sendEvent:(UIEvent*)evt
{
    /*
    UITouch * t = [[evt allTouches] anyObject];
    NSLog(@"event received: %@, %@", evt, t.view.gestureRecognizers);
    [t describe];
    [super sendEvent:evt];
    NSLog(@"event processed: %@, %@", evt, t.view.gestureRecognizers);
    [t describe];
    */
    [super sendEvent:evt];
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)evt
{
}
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)evt
{
}
-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)evt
{
}
-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)evt
{
}
@end
