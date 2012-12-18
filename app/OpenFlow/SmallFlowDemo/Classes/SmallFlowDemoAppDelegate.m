//
//  SmallFlowDemoAppDelegate.m
//  SmallFlowDemo
//
//  Created by Dirk on 19.08.09.
//  Copyright holtwick.it 2009. All rights reserved.
//

#import "SmallFlowDemoAppDelegate.h"
#import "SmallFlowDemoViewController.h"

@implementation SmallFlowDemoAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
