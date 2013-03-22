@class LPPlugin;
@class LPPaper;

@interface LPPreview : NSObject
{
    LPPlugin * plugin;
    LPPaper * paper;
    NSDictionary * initInfo;
    UIViewController * viewController;
    UIViewController * prefsViewController;
    BOOL triedLoadingPrefs;
    BOOL hasPrefs;
    BOOL hidden;
}

@property(nonatomic, readonly) UIViewController * viewController;
@property(nonatomic, assign) LPPaper * paper;
@property(nonatomic, readonly) LPPlugin * plugin;
@property(nonatomic, readonly) UIViewController * prefsViewController;
@property(nonatomic, getter=isHidden) BOOL hidden;

- (id)initWithPaper:(LPPaper*)paper;
- (BOOL)hasPreferences;
@end
