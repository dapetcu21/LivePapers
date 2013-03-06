//==============================================================================
//
//  InfColorIndicatorView.h
//  InfColorPicker
//
//  Created by Troy Gaul on 8/10/10.
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

//------------------------------------------------------------------------------

@interface InfColorIndicatorView : UIView

@property( retain, nonatomic ) UIColor* color;

@end

//------------------------------------------------------------------------------
