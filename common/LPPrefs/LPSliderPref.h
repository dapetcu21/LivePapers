#import "LPPref.h"
#import "LPClassGuard.h"

#define prefSlider(_tag, _text, _format, _minimumValue, _maximumValue) do { \
    LPSliderPref * pref = [LPSliderPref new]; \
    pref.text = _text; \
    pref.format = _format; \
    pref.tag = _tag; \
    pref.minimumValue = _minimumValue; \
    pref.maximumValue = _maximumValue; \
    [self addPref:pref]; \
    [pref release]; \
} while(0)

@interface LPSliderPref : LPPref
{
    UISlider * slider;
    UILabel * label, * statusLabel;
    NSString * format;
    float min, max;
}
@property(nonatomic, retain) NSString * text;
@property(nonatomic, retain) NSString * format;
@property(nonatomic, assign) float minimumValue;
@property(nonatomic, assign) float maximumValue;

@end;

