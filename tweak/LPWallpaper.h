@class UIViewController, LPPlugin;

@interface LPWallpaper : NSObject
{
    NSString * name;
    LPPlugin * plugin;
    UIViewController * vc;
}

@property(nonatomic, readonly) NSString * name;
@property(nonatomic, readonly) UIViewController * viewController;

-(id)initWithName:(NSString*)name;
-(UIViewController*)viewController;

@end
