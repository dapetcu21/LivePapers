#include <UIKit/UIKit.h>

@class LPWallpaper, LPScreenView, LPIntermediateVC;

@interface LPView : UIView
{
    int orient;
    LPWallpaper * paper;
    LPIntermediateVC * vc;
    UIImage * image;
    UIImage * screen;
    UIImageView * shotView;
    CGRect imageRect;
    BOOL alreadyScreened;
}

@property(nonatomic, assign) int orientation;
@property(nonatomic, assign) int variant;
@property(nonatomic, retain) LPWallpaper * wallpaper;
@property(nonatomic, retain) LPIntermediateVC * viewController;

-(UIImage*)screenshot;
-(UIImage*)image;
-(void)setOrientation:(int)o duration:(float)dur;
-(void)setWallImage:(UIImage*)img;
-(void)setWallRect:(CGRect)rect;

-(id)initWithOrientation:(int)o variant:(int)v;

@end
