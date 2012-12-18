/**
 * Copyright (c) 2009 Alex Fajkowski, Apparent Logic LLC
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
#import "AFOpenFlowViewController.h"
#import "UIImageExtras.h"
#import "AFGetImageOperation.h"


@implementation AFOpenFlowViewController

@synthesize openFlowView; 

- (void)dealloc {
	[loadImagesOperationQueue release];
    [super dealloc];
}

- (void)awakeFromNib {
	loadImagesOperationQueue = [[NSOperationQueue alloc] init];
	UIAlertView *openFlowImageSourceAlertView = [[UIAlertView alloc] initWithTitle:@"OpenFlow Demo Data Source" 
																		   message:@"Sample Load method?" 
																		  delegate:self 
																 cancelButtonTitle:@"All at once"
																 otherButtonTitles:@"NSThread", nil];
	[openFlowImageSourceAlertView show];
	[openFlowImageSourceAlertView release];
}

- (IBAction)infoButtonPressed:(id)sender {
	NSString *alertString;

	alertString = @"Sample images included in this project are all in the public domain, courtesy of NASA.";
	UIAlertView *infoAlertPanel = [[UIAlertView alloc] initWithTitle:@"OpenFlow Demo App" 
															 message:[NSString stringWithFormat:@"%@\n\nFor more info about the OpenFlow API, visit apparentlogic.com.", alertString]
															delegate:nil 
												   cancelButtonTitle:nil 
												   otherButtonTitles:@"Dismiss", nil];
	[infoAlertPanel show];
	[infoAlertPanel release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	self.openFlowView.continousLoop = YES; 
	[(AFOpenFlowView *)self.view reloadData];
	
	
	// Assume we're in the initial alert view.
	if (buttonIndex == 0) {
		// Use sample images, but load them all at once.
		NSString *imageName;
		for (int i=0; i < 30; i++) {
			imageName = [[NSString alloc] initWithFormat:@"%d.jpg", i];
			[(AFOpenFlowView *)self.view setImage:[UIImage imageNamed:imageName] forIndex:i];
			[imageName release];
		}
	}
}

- (void)imageDidLoad:(NSArray *)arguments {
	UIImage *loadedImage = (UIImage *)[arguments objectAtIndex:0];
	NSNumber *imageIndex = (NSNumber *)[arguments objectAtIndex:1];
	
	[(AFOpenFlowView *)self.view setImage:loadedImage forIndex:[imageIndex intValue]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (UIImage *)defaultImage {
	return [UIImage imageNamed:@"coverdefault.png"];
}

- (NSInteger) numberOfImagesInOpenView:(AFOpenFlowView *)openFlowView {
	return 30;
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView requestImageForIndex:(NSInteger)index {
	AFGetImageOperation *getImageOperation = [[AFGetImageOperation alloc] initWithIndex:index viewController:self];	
	[loadImagesOperationQueue addOperation:getImageOperation];
	[getImageOperation release];
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(NSInteger)index {
	NSLog(@"Cover Flow selection did change to %d", index);
}

@end