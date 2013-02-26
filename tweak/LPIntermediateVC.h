#import <UIKit/UIKit.h>

@interface LPIntermediateVC : UIViewController
{
    UIViewController * vc;
    BOOL screenLit, viewShowing;
    int currentVariant;
    BOOL screenshotShowing;
    BOOL active[2];
}
@property(nonatomic,assign) BOOL screenLit;
@property(nonatomic,assign) BOOL viewShowing;
@property(nonatomic,assign) BOOL screenshotShowing;
@property(nonatomic,assign) int currentVariant;

-(void)setActive:(BOOL)a forVariant:(int)var;

-(id)initWithViewController:(UIViewController*)vc;
-(void)updateWithOldMask:(BOOL)m;

-(void)setWallpaperImage:(UIImage*)img;
-(void)setWallpaperRect:(CGRect)rect;
-(void)reloadPreferences;
-(void)resetIdleTimer;

-(BOOL)knowsScreenShot;
-(UIImage*)screenShot;

-(BOOL)showingOverall;

@end
