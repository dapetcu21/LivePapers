#ifndef LPCLASSGUARD_H
#define LPCLASSGUARD_H

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
#define LPColorWheel PH_TOKENPASTE(LPColorWheel, PH_APP_TARGET)

#endif
