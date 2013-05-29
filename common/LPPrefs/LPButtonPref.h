#import "LPPref.h"
#import "LPClassGuard.h"

#define prefButton(_tag, _text) do { \
    LPButtonPref * pref = [LPButtonPref new]; \
    pref.text = _text; \
    pref.tag = _tag; \
    [self addPref:pref]; \
    [pref release]; \
} while(0)

@interface LPButtonPref : LPPref
{
    UIButton * button;
}
@property(nonatomic, retain) NSString * text;

@end;

