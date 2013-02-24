#import <UIKit/UIKit.h>
@class LPView;

@interface LPScreenView : UIView
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
    
    LPView * master;
    int orient;
}

@property(nonatomic, assign) int orientation;

-(void)setOrientation:(int)o duration:(float)f;
-(id)initWithMasterView:(LPView*)v;

@end
