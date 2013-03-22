#ifndef LPCLASSGUARD_H
#define LPCLASSGUARD_H

#ifndef LP_TOKENPASTE
#define LP_TOKENPASTE2(a, b) a ## b
#define LP_TOKENPASTE(a, b) LP_TOKENPASTE2(a, b)
#endif

#define LPColorPref LP_TOKENPASTE(LPColorPref, PH_APP_TARGET)
#define LPDatePref LP_TOKENPASTE(LPDatePref, PH_APP_TARGET)
#define LPPref LP_TOKENPASTE(LPPref, PH_APP_TARGET)
#define LPPrefs LP_TOKENPASTE(LPPrefs, PH_APP_TARGET)
#define LPPrefsViewController LP_TOKENPASTE(LPPrefsViewController, PH_APP_TARGET)
#define LPSegmentPref LP_TOKENPASTE(LPSegmentPref, PH_APP_TARGET)
#define LPSliderPref LP_TOKENPASTE(LPSliderPref, PH_APP_TARGET)
#define LPSwitchPref LP_TOKENPASTE(LPSwitchPref, PH_APP_TARGET)

#endif
