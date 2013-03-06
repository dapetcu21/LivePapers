//==============================================================================
//
//  InfColorPickerController.h
//  InfColorPicker
//
//  Created by Troy Gaul on 7 Aug 2010.
//
//  Copyright (c) 2011 InfinitApps LLC - http://infinitapps.com
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import "LPClassGuard.h"
#import <UIKit/UIKit.h>

#ifndef PH_TOKENPASTE
#define _PH_TOKENPASTE(x, y) x ## y
#define PH_TOKENPASTE(x, y) _PH_TOKENPASTE(x, y)
#endif

#define InfColorBarPicker PH_TOKENPASTE(InfColorBarPicker, PH_APP_TARGET)
#define InfColorBarView PH_TOKENPASTE(InfColorBarView, PH_APP_TARGET)
#define InfColorIndicatorView PH_TOKENPASTE(InfColorIndicatorView, PH_APP_TARGET)
#define InfColorPickerController PH_TOKENPASTE(InfColorPickerController, PH_APP_TARGET)
#define InfColorSquarePicker PH_TOKENPASTE(InfColorSquarePicker, PH_APP_TARGET)
#define InfColorSquareView PH_TOKENPASTE(InfColorSquareView, PH_APP_TARGET)
#define InfSourceColorView PH_TOKENPASTE(InfSourceColorView, PH_APP_TARGET)

@class InfColorBarView;
@class InfColorSquareView;
@class InfColorBarPicker;
@class InfColorSquarePicker;

@protocol InfColorPickerControllerDelegate;

//------------------------------------------------------------------------------

@interface InfColorPickerController : UIViewController {
	float hue;
	float saturation;
	float brightness;
}

	// Public API:

+ (InfColorPickerController*) colorPickerViewController;
+ (CGSize) idealSizeForViewInPopover;

- (void) presentModallyOverViewController: (UIViewController*) controller;

@property( retain, nonatomic ) UIColor* sourceColor;
@property( retain, nonatomic ) UIColor* resultColor;

@property( assign, nonatomic ) id< InfColorPickerControllerDelegate > delegate;

	// IB outlets:

@property( retain, nonatomic ) IBOutlet InfColorBarView* barView;
@property( retain, nonatomic ) IBOutlet InfColorSquareView* squareView;
@property( retain, nonatomic ) IBOutlet InfColorBarPicker* barPicker;
@property( retain, nonatomic ) IBOutlet InfColorSquarePicker* squarePicker;
@property( retain, nonatomic ) IBOutlet UIView* sourceColorView;
@property( retain, nonatomic ) IBOutlet UIView* resultColorView;
@property( retain, nonatomic ) IBOutlet UINavigationController* navController;

@end

//------------------------------------------------------------------------------

@protocol InfColorPickerControllerDelegate

@optional

- (void) colorPickerControllerDidFinish: (InfColorPickerController*) controller;
	// This is only called when the color picker is presented modally.

- (void) colorPickerControllerDidChangeColor: (InfColorPickerController*) controller;

@end

//------------------------------------------------------------------------------
