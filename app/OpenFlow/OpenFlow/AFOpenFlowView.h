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
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "AFItem.h"
#import "AFOpenFlowViewDelegate.h"
#import "AFOpenFlowViewDataSource.h"


@interface AFOpenFlowView : UIView {
	id <AFOpenFlowViewDataSource> dataSource;
	id <AFOpenFlowViewDelegate> viewDelegate;
	
	//Open Flow Configuration
	BOOL continousLoop; 
	CGFloat coverSpacing; 
	CGFloat centerCoverOffset; 
	CGFloat sideCoverAngle; 
	CGFloat sideCoverZPosition; 
	NSInteger coverBuffer; 
	CGFloat dragDivisor; 
	CGFloat sideOffset;
	CGFloat reflectionFraction; 
	CGFloat coverHeightOffset; 
	CGFloat coverImageSize; 

    CGFloat flipRotation;
	
	UIColor *backingColor;
	
	NSMutableDictionary *allScreenCovers;
	NSMutableDictionary *onScreenCovers;
	UIImage	*defaultImage;
	CGFloat	defaultImageHeight;
    
	NSInteger numberOfImages;
	NSInteger beginningCover;
	
	AFItem *selectedCoverView;
	
	CATransform3D leftTransform, rightTransform;
	
	Boolean isSingleTap;
	Boolean isDoubleTap;
	Boolean isDraggingACover;
	CGFloat startPosition;
	NSInteger selectedCoverAtDragStart; 
	CGFloat dragOffset; 
	CGPoint startPoint;
    UIView * flipView;
}

@property (assign, nonatomic) id <AFOpenFlowViewDataSource> dataSource;
@property (assign, nonatomic) id <AFOpenFlowViewDelegate> viewDelegate;

@property (assign, nonatomic) BOOL continousLoop; 
@property (assign, nonatomic) CGFloat coverSpacing; 
@property (assign, nonatomic) CGFloat centerCoverOffset; 
@property (assign, nonatomic) CGFloat sideCoverAngle; 
@property (assign, nonatomic) CGFloat sideCoverZPosition; 
@property (assign, nonatomic) NSInteger coverBuffer; 
@property (assign, nonatomic) CGFloat dragDivisor; 
@property (assign, nonatomic) CGFloat sideOffset; 
@property (assign, nonatomic) CGFloat reflectionFraction; 
@property (assign, nonatomic) CGFloat coverHeightOffset; 
@property (assign, nonatomic) CGFloat coverImageSize; 

@property (retain, nonatomic) UIColor *backingColor; 

@property (retain, nonatomic) NSMutableDictionary *allScreenCovers;
@property (retain, nonatomic) NSMutableDictionary *onScreenCovers;
@property (retain, nonatomic) UIImage *defaultImage;
@property NSInteger numberOfImages;
@property (retain, nonatomic) AFItem *selectedCoverView;
@property (readonly, nonatomic) UIView * flipView;

- (void)reloadData; 
- (void)setSelectedCover:(NSInteger)newSelectedCover;
- (void)setImage:(UIImage *)image forIndex:(NSInteger)index;
- (void)setImage:(UIImage *)image forIndex:(NSInteger)index animated:(BOOL)anim;
- (CGRect)previewFrameForIndex:(NSInteger)index;
- (void)flipWithView:(UIView*)view;

@end
