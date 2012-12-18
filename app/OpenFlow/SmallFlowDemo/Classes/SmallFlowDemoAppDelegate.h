//
//  SmallFlowDemoAppDelegate.h
//  SmallFlowDemo
//
//  Created by Dirk on 19.08.09.
//  Copyright holtwick.it 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SmallFlowDemoViewController;

@interface SmallFlowDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SmallFlowDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SmallFlowDemoViewController *viewController;

@end

