@class LPIntermediateVC, LPPlugin;

@interface LPWallpaper : NSObject
{
    NSString * name;
    LPPlugin * plugin;
    LPIntermediateVC * vc;
}

@property(nonatomic, readonly) NSString * name;
@property(nonatomic, readonly) LPIntermediateVC * viewController;

-(id)initWithName:(NSString*)name;
-(LPIntermediateVC*)viewController;
-(void)reloadPreferences;

@end
