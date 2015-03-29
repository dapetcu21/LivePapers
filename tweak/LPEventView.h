#import <UIKit/UIKit.h>
//#define LPEVENTVIEW_ISWINDOW

#ifdef LPEVENTVIEW_ISWINDOW
@interface LPEventView : UIWindow
#else
@interface LPEventView : UIView
#endif
{
}

-(void)sendEvent:(UIEvent*)evt;
@end
