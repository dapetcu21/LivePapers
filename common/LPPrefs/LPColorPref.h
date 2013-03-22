#import "LPPref.h"
#import "LPClassGuard.h"

#define prefColor(_tag, _text) { \
    LPColorPref * pref = [[LPColorPref alloc] initWithController:self]; \
    pref.text = _text; \
    pref.tag = _tag; \
    [self addPref:pref]; \
    [pref release]; \
}

@interface LPColorPref : LPPref
{
    UILabel * label;
    UIView * colorWheel;
}
@property(nonatomic, retain) NSString * text;

-(id)initWithController:(LPPrefsViewController*)controller;
@end;

