@interface LPPlugin : NSObject
{
    void * handle;
    UIViewController * (*vcFunction)(void*);
    UIViewController * (*prefsFunction)(void*);
    int (*hasPrefsFunction)(void*);
}
- (id)initWithName:(NSString*)name;
- (UIViewController*)viewControllerWithUserInfo:(void*)userInfo;
- (UIViewController*)preferencesViewControllerWithUserInfo:(void*)userInfo;
- (BOOL)hasPreferences:(void*)userInfo;
@end
