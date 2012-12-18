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
#import "AFItem.h"
#import <QuartzCore/QuartzCore.h>
#import "AFOpenFlowConstants.h"


@implementation AFItem

@synthesize imageRequested; 
@synthesize imageLayer;
@synthesize number;

- (id) init {
	self = [super init];
	if (self != nil) {
		self.imageLayer = [CALayer layer]; 
		self.imageRequested = NO; 
	}
	return self;
}

- (void)setImage:(UIImage *)newImage
	backingColor:(UIColor *)backingColor 
       imageScale:(CGFloat) scale 
{
    NSLog(@"scale %f", scale * newImage.size.width);
	self.imageLayer.frame = CGRectMake(0, 0, newImage.size.width * scale, newImage.size.height * scale);
	[self.imageLayer setContents:(id)[newImage CGImage]];
	self.imageLayer.name = @"Image Layer";
	self.imageLayer.backgroundColor = [backingColor CGColor];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"AFItemView - Cover %d layer position: %0.0f:%0.0f:%0.0f", self.number,
			self.imageLayer.position.x, self.imageLayer.position.y, self.imageLayer.zPosition]; 
}

- (void)dealloc {
	[self.imageLayer removeFromSuperlayer];
	self.imageLayer = nil; 
	[super dealloc];
}

@end
