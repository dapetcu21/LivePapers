@class LPPaper;

@interface LPPreviewView : UIView
{
    CGRect normalFrame;
    CGRect fullScreenFrame;
    LPPaper * paper;
    UIView * view;
    BOOL fullScreen;
}

- (id)initWithFrame:(CGRect)frame;

@property(nonatomic, retain) LPPaper * paper;
@property(nonatomic, assign) CGRect fullScreenFrame;
@property(nonatomic, readonly) UIImage * screenShot;
@property(nonatomic, assign) BOOL fullScreen;

- (void)toggleFullScreen;
@end
