@interface LPPlugin : NSObject
{
    void * handle;
    UIViewController * (*vcFunction)(void*);
    UIViewController * (*prefsFunction)(void*);
}
- (id)initWithName:(NSString*)name;
- (UIViewController*)viewControllerWithUserInfo:(void*)userInfo;
- (UIViewController*)preferencesViewControllerWithUserInfo:(void*)userInfo;
@end
