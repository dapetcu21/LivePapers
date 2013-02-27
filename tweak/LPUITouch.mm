#import <UIKit/UITouch2.h>
#import <substrate.h>
#import "LPUITouch.h"

@implementation UITouch (LPSynthesize)

-(id)initFromTouch:(UITouch*)touch inView:(UIView*)view
{
    if ((self = [super init]))
    {
        UIView * target = [view hitTest:[touch locationInView:view] withEvent:nil];
        if (!target)
        {
            [self release];
            return nil;
        }
        [self _loadStateFromTouch:touch];
        self.view = target;
        self.window = target.window;
    }
    return self;
}

-(void)syncWithTouch:(UITouch*)touch
{
    UIView * v = self.view;
    [self _loadStateFromTouch:touch];
    self.view = v;
    self.window = v.window;
}

-(void)changeToPhase:(UITouchPhase)phase
{
    self.phase = phase;
    self.timestamp = [NSDate timeIntervalSinceReferenceDate];
}

@end
