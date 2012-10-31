#import <UIKit/UIKit.h>
@class LPView;

@interface LPScreenView : UIImageView
{
    LPView * master;
    int orient;
}

@property(nonatomic, assign) int orientation;

-(void)setOrientation:(int)o duration:(float)f;
-(id)initWithMasterView:(LPView*)v;

@end
