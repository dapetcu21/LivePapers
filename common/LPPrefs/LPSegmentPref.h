#import "LPPref.h"
#import "LPClassGuard.h"

#define prefSegment(_tag, _text, ...) do { \
    LPSegmentPref * pref = [[LPSegmentPref alloc] initWithItems:[NSArray arrayWithObjects:__VA_ARGS__, nil]]; \
    pref.text = _text; \
    pref.tag = _tag; \
    [self addPref:pref]; \
    [pref release]; \
} while (0)

@interface LPSegmentPref : LPPref
{
    UILabel * label;
    UISegmentedControl * segmentedControl;
}
@property(nonatomic, retain) NSString * text;
-(id)initWithItems:(NSArray*)items;

@end;

