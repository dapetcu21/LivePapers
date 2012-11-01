#import <UIKit/UIKit.h>

@interface LPIntermediateVC : UIViewController
{
    UIViewController * vc;
    BOOL screenLit, viewShowing;
}
@property(nonatomic,assign) BOOL screenLit;
@property(nonatomic,assign) BOOL viewShowing;

-(id)initWithViewController:(UIViewController*)vc;
-(void)updateWithOldMask:(BOOL)m;

-(void)setWallpaperImage:(UIImage*)img;
-(void)setWallpaperRect:(CGRect)rect;

@end
