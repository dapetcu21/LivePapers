#import "AFOpenFlowView.h"
#import "AFOpenFlowViewDelegate.h"
#import "AFOpenFlowViewDataSource.h"

@class LPPaper;

@interface RootViewController: UIViewController<AFOpenFlowViewDataSource, AFOpenFlowViewDelegate> {
    AFOpenFlowView * flowView;
    UIImage * defaultImage; 
    NSMutableArray * papers;
    UILabel * label;
    UIImageView * background;
    UIImageView * bar;
    UIButton * homeButton, * lockButton, * settingsButton;
    UIImageView * homeBadge, * lockBadge;
    UIView * container;

    NSString * homePaper, * lockPaper;
}

- (void)loadPapers;
- (void)selectedPaper:(LPPaper*)p;
- (void)saveSettings:(NSString*)s;

@end
