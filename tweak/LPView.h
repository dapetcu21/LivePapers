#include <UIKit/UIKit.h>

@class LPWallpaper, LPScreenView;

@interface LPView : UIView
{
    int orient;
    LPWallpaper * paper;
    UIViewController * vc;
    UIImage * image;
    UIImage * screen;
    UIImageView * shotView;
    CGRect imageRect;
}

@property(nonatomic, assign) int orientation;
@property(nonatomic, assign) int variant;
@property(nonatomic, retain) LPWallpaper * wallpaper;
@property(nonatomic, retain) UIViewController * viewController;

-(UIImage*)screenshot;
-(UIImage*)image;
-(void)setOrientation:(int)o duration:(float)dur;
-(void)setWallImage:(UIImage*)img;
-(void)setWallRect:(CGRect)rect;

-(id)initWithOrientation:(int)o variant:(int)v;

@end
