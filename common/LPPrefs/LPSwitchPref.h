#import "LPPref.h"
#import "LPClassGuard.h"

#define prefSwitch(_tag, _text) do { \
    LPSwitchPref * pref = [LPSwitchPref new]; \
    pref.text = _text; \
    pref.tag = _tag; \
    [self addPref:pref]; \
    [pref release]; \
} while(0)

@interface LPSwitchPref : LPPref
{
    UILabel * label;
    UISwitch * sw;
}
@property(nonatomic, retain) NSString * text;

@end;

