#include <UIKit/UIKit.h>

@class LPWallpaper, LPScreenView, LPIntermediateVC;

@interface LPView : UIView
{
    //in case anybody tries to change the ivars
	int _orientation;
	int _variant;
	UIImageView* _topGradient;
	UIImageView* _bottomGradient;
	BOOL _usesFilter;
	float _gradientAlpha;
	CGRect _wallpaperContentsRect;
	BOOL _postsNotifications;
	BOOL _flushWallpaperAutomatically;
    

    int orient;
    LPWallpaper * paper;
    LPIntermediateVC * vc;
    UIImage * image;
    UIImage * screen;
    UIImageView * shotView;
    CGRect imageRect;
    BOOL alreadyScreened;
    int screenViews;
}

@property(nonatomic, assign) int orientation;
@property(nonatomic, assign) int variant;
@property(nonatomic, assign) float alpha; //dummy
@property(nonatomic, retain) LPWallpaper * wallpaper;
@property(nonatomic, retain) LPIntermediateVC * viewController;

-(UIImage*)screenshot;
-(UIImage*)image;
-(void)setImage:(UIImage*)img;
-(void)setOrientation:(int)o duration:(float)dur;
-(void)setWallImage:(UIImage*)img;
-(void)setWallRect:(CGRect)rect;

-(id)initWithOrientation:(int)o variant:(int)v;
-(void)resetCurrentImageToWallpaper;
-(void)replaceWallpaperWithImage:(UIImage*)image;

-(void)addScreenView;
-(void)removeScreenView;
-(void)updateScreenView;

@end
