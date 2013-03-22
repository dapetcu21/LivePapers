#import <UIKit/UIKit.h>
#import "LPClassGuard.h"

#define prefSpacer(_tag) { \
    LPPref * pref = [LPPref new]; \
    pref.tag = _tag; \
    [self addPref:pref]; \
    [pref release]; \
}
#define prefSpacer_() prefSpacer(-1)

@class LPPrefsViewController;
@interface LPPref : NSObject
{
    int tag;
    BOOL hidden;
    UIView * view;
    LPPrefsViewController * controller;
}
@property(nonatomic, assign) int tag;
@property(nonatomic, readonly) UIView * view;
@property(nonatomic, assign) LPPrefsViewController * controller;
@property(nonatomic, assign, getter=isHidden) BOOL hidden;

@property(nonatomic, assign) float floatValue;
@property(nonatomic, assign) int intValue;
@property(nonatomic, assign) BOOL boolValue;
@property(nonatomic, retain) id objectValue;

@end
