//
//  SmallFlowDemoViewController.h
//  SmallFlowDemo
//
//  Created by Dirk on 19.08.09.
//  Copyright holtwick.it 2009. All rights reserved.
//

#import "XBase.h"
#import "AFOpenFlowView.h"

@interface SmallFlowDemoViewController : UIViewController <AFOpenFlowViewDelegate> {
    XIBOUTLET AFOpenFlowView *smallOpenFlowView_;
    XIBOUTLET UILabel *titleLabel_;
    XIBOUTLET UIView *overlayView_;
}

@property (nonatomic, retain) IBOutlet UIView *overlayView;
@property (nonatomic, retain) IBOutlet AFOpenFlowView *smallOpenFlowView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

@end

