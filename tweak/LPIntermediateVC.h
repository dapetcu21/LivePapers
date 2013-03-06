#import <UIKit/UIKit.h>
#ifdef __cplusplus
#include <map>
#endif

@interface LPIntermediateVC : UIViewController
{
    UIViewController * vc;
    BOOL screenLit, viewShowing;
    int currentVariant;
    BOOL screenshotShowing;
    BOOL interactive;
    BOOL active[2];

#ifdef __cplusplus
    std::map<UITouch*, UITouch*> * touches;
#else
    void * touches;
#endif
    
    UIEvent * savedEvent;
}
@property(nonatomic,assign) BOOL screenLit;
@property(nonatomic,assign) BOOL viewShowing;
@property(nonatomic,assign) BOOL screenshotShowing;
@property(nonatomic,assign) int currentVariant;
@property(nonatomic,retain) UIEvent * savedEvent;
@property(nonatomic,assign) BOOL interactive;

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

-(void)relayEvent:(UIEvent*)evt;
-(void)cancelAllCurrentTouches;

@end
