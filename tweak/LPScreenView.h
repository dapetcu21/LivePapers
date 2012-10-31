#import <UIKit/UIKit.h>

@interface LPScreenView : UIImageView
{
    UIView * master;
    int orient;
}

@property(nonatomic, assign) int orientation;

-(void)setOrientation:(int)o duration:(float)f;
-(id)initWithMasterView:(UIView*)v;

@end
