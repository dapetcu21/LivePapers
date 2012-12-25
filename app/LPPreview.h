@class LPPlugin;
@class LPPaper;

@interface LPPreview : NSObject
{
    LPPlugin * plugin;
    LPPaper * paper;
    UIViewController * viewController;
    UIViewController * prefsViewController;
    BOOL triedLoadingPrefs;
}

@property(nonatomic, readonly) UIViewController * viewController;
@property(nonatomic, assign) LPPaper * paper;
@property(nonatomic, readonly) LPPlugin * plugin;
@property(nonatomic, readonly) UIViewController * prefsViewController;

- (id)initWithPaper:(LPPaper*)paper;
@end
