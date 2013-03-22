#import <UIKit/UIKit.h>
#import "LPClassGuard.h"

@class LPPref;
@interface LPPrefsViewController : UIViewController
{
    NSMutableArray * prefs;
    BOOL animateTransitions;
}
@property(nonatomic, assign) UIViewController * rootViewController;
@property(nonatomic, assign) BOOL animateTransitions;

-(NSArray*)allPrefs;
-(void)addPref:(LPPref*)pref;
-(LPPref*)prefWithTag:(int)tag;

-(void)prefDidChange:(LPPref*)pref;

-(void)_prefToggledHidden:(LPPref*)pref;
@end
