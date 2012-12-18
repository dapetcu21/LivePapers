/*
 *  XBase.h
 *
 *  Little helper for the 'xobjc' convienience tool:
 *  http://github.com/holtwick/xobjc/tree
 *
 *  Created by Dirk on 12.08.09.
 *  Copyright 2009 holtwick.it. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

#define XASSIGN
#define XRETAIN 
#define XCOPY 
#define XATOMIC 
#define XREADONLY
#define XIBOUTLET

// Animation stuff

#define ANIMATION_BEGIN(secs) \
[UIView beginAnimations:nil context:nil]; \
[UIView setAnimationDuration:secs]; \
[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

#define ANIMATION_END \
[UIView commitAnimations];     

#define ANIMATION_NEXT(secs, next) \
[UIView setAnimationDelegate:self]; \
[UIView setAnimationDidStopSelector:@selector(next)]; \
[UIView commitAnimations]; } \
- (void)next { \
[UIView beginAnimations:nil context:nil]; \
[UIView setAnimationDuration:secs]; \
[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

#define ANIMATION_LAST(next) \
[UIView setAnimationDelegate:self]; \
[UIView setAnimationDidStopSelector:@selector(next)]; \
[UIView commitAnimations]; } \
- (void)next {
