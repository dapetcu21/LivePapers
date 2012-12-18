//
//  SmallFlowDemoViewController.m
//  SmallFlowDemo
//
//  Created by Dirk on 19.08.09.
//  Copyright holtwick.it 2009. All rights reserved.
//

/* 
  
 TODO:
  - When the element is put inside a table view it is very picky about horizontal and vertical movements
 
 */

#import "SmallFlowDemoViewController.h"

@implementation SmallFlowDemoViewController

@synthesize overlayView = overlayView_;
@synthesize smallOpenFlowView = smallOpenFlowView_;
@synthesize titleLabel = titleLabel_;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load the sample images
	[self.smallOpenFlowView setViewDelegate:self];
    for (int i=0; i < 30; i++) {
        [self.smallOpenFlowView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]] forIndex:i];
    }
    [self.smallOpenFlowView setNumberOfImages:30];   
	self.smallOpenFlowView.coverHeightOffset = 12.0;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc{
    [overlayView_ release];
    [smallOpenFlowView_ release];
    [titleLabel_ release];
    [super dealloc];
}

// MARK: OpenFlowViewDelegate

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index {
    // Set a title showing us which is the current cover shown
    [titleLabel_ setText:[NSString stringWithFormat:@"Item #%d", index]];
}

- (void)openFlowViewAnimationDidBegin:(AFOpenFlowView *)openFlowView {
    [overlayView_ setAlpha:0.0];
}

- (void)openFlowViewAnimationDidEnd:(AFOpenFlowView *)openFlowView {
    ANIMATION_BEGIN(0.75)
    [overlayView_ setAlpha:1.0];
    ANIMATION_END
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView didTap:(int)index {
    NSLog(@"Tapped on %d", index);
    [[[[UIAlertView alloc] initWithTitle:@"Info" message:[NSString stringWithFormat:@"You tapped on item #%d", index] delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles:nil] autorelease] show];
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView didDoubleTap:(int)index {
    NSLog(@"Tapped twice on %d", index);
}

@end
