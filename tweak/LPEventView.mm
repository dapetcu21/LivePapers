#import "LPEventView.h"
#import "LPUITouch.h"
#include <map>

#define _PASTE(a, b) a ## b
#define PASTE(a, b) _PASTE(a, b)

@implementation LPEventView

-(id)initWithFrame:(CGRect)r
{
    if ((self = [super initWithFrame:r]))
    {
#ifdef LPEVENTVIEW_ISWINDOW
        self.windowLevel = -100;
        self.hidden = NO;
#endif
    }
    return self;
}

-(void)sendEvent:(UIEvent*)evt
{
#ifdef LPEVENTVIEW_ISWINDOW
    /*
    UITouch * t = [[evt allTouches] anyObject];
    NSLog(@"event received: %@, %@", evt, t.view.gestureRecognizers);
    [t describe];
    [super sendEvent:evt];
    NSLog(@"event processed: %@, %@", evt, t.view.gestureRecognizers);
    [t describe];
    */
    [super sendEvent:evt];
#else
    static std::map<UIView*, NSMutableSet*> touches[4];
    for (int i = 0; i < 4; i++)
        touches[i].clear();
    #define phase_name0 Began
    #define phase_name1 Moved
    #define phase_name2 Ended
    #define phase_name3 Cancelled
    for (UITouch * touch in [evt allTouches])
    {
        int count;
        switch (touch.phase)
        {
            #define phase_case(idx) \
            case PASTE(UITouchPhase, PASTE(phase_name, idx)): \
                count = idx; \
                break;
            phase_case(0)
            phase_case(1)
            phase_case(2)
            phase_case(3)
            default:
                continue;
        }
        UIView * v = touch.view;
        std::map<UIView*, NSMutableSet*>::iterator i = touches[count].find(v);
        if (i == touches[count].end())
            i = touches[count].insert(std::make_pair(v, [[[NSMutableSet alloc] init] autorelease])).first;
        [i->second addObject:touch];
    }
    #define call_loop(phase) \
    for (std::map<UIView*, NSMutableSet*>::iterator i = touches[phase].begin(); i != touches[phase].end(); i++) \
        [i->first PASTE(touches, PASTE(phase_name, phase)): i->second withEvent:evt];
    call_loop(0)
    call_loop(1)
    call_loop(2)
    call_loop(3)
#endif
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
