#import <UIKit/UITouch2.h>
#import <substrate.h>
#import "LPUITouch.h"

@implementation UITouch (LPSynthesize)

-(id)initFromTouch:(UITouch*)touch inView:(UIView*)view
{
    if ((self = [super init]))
    {
        [self _loadStateFromTouch:touch];

        UIView * target = view ? [view hitTest:[touch locationInView:view] withEvent:nil] : nil;
        if (target)
        {
            self.view = target;
            self.window = target.window;
        } else {
            self.view = nil;
            self.window = nil;
        }
    }
    return self;
}

-(void)syncWithTouch:(UITouch*)touch
{
    UIView * v = self.view;
    UIWindow * w = self.window;
    [self _loadStateFromTouch:touch];
    self.view = v;
    self.window = w;
}

-(void)changeToPhase:(UITouchPhase)phase
{
    self.phase = phase;
    self.timestamp = [NSDate timeIntervalSinceReferenceDate];
}

struct PHUITouchFlags {
    unsigned _firstTouchForView : 1;
    unsigned _isTap : 1;
    unsigned _isDelayed : 1;
    unsigned _sentTouchesEnded : 1;
    unsigned _abandonForwardingRecord : 1;
} ;

-(void)describe
{
    #define prop(p, f) [dict setObject:[NSString stringWithFormat:@ f, p] forKey:@ #p]

    NSMutableDictionary * dict = [NSMutableDictionary new];

    prop(MSHookIvar<double>(self, "_timestamp"), "%lf");
    prop(MSHookIvar<int>(self, "_phase"), "%d");
    prop(MSHookIvar<int>(self, "_savedPhase"), "%d");
    prop(MSHookIvar<unsigned>(self, "_tapCount"), "%u");
    prop(MSHookIvar<id>(self, "_window"), "%@");
    prop(MSHookIvar<id>(self, "_view"), "%@");
    prop(MSHookIvar<id>(self, "_gestureView"), "%@");
    prop(MSHookIvar<id>(self, "_warpedIntoView"), "%@");
    prop(MSHookIvar<id>(self, "_gestureRecognizers"), "%@");
    prop(MSHookIvar<id>(self, "_forwardingRecord"), "%@");
    prop(MSHookIvar<CGPoint>(self, "_locationInWindow").x, "%f");
    prop(MSHookIvar<CGPoint>(self, "_locationInWindow").y, "%f");
    prop(MSHookIvar<CGPoint>(self, "_previousLocationInWindow").x, "%f");
    prop(MSHookIvar<CGPoint>(self, "_previousLocationInWindow").y, "%f");
    prop(MSHookIvar<id>(self, "_pathIndex"), "%uc");
    prop(MSHookIvar<id>(self, "_pathIdentity"), "%uc");
    prop(MSHookIvar<id>(self, "_pathMajorRadius"), "%f");
    PHUITouchFlags _touchFlags = MSHookIvar<PHUITouchFlags>(self, "_touchFlags");
    prop(_touchFlags._firstTouchForView, "%u");
    prop(_touchFlags._isTap, "%u");
	prop(_touchFlags._isDelayed, "%u");
	prop(_touchFlags._sentTouchesEnded, "%u");
    prop(_touchFlags._abandonForwardingRecord, "%u");

    NSLog(@"%@", dict);
}

-(void)_setWindow:(UIWindow*)w
{
    self.window = w;
}

@end
