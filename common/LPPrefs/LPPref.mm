#import "LPPref.h"
#import "LPPrefsViewController.h"

@implementation LPPref
@synthesize tag;
@synthesize view;
@synthesize controller;

-(id)init
{
    if ((self = [super init]))
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 20.0f)];
        view.autoresizesSubviews = YES;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

-(void)dealloc
{
    [view release];
    [super dealloc];
}

-(void)setFloatValue:(float)v
{
}

-(void)setIntValue:(int)v
{
    [self setFloatValue:v];
}

-(void)setBoolValue:(BOOL)v
{
    [self setIntValue:v];
}

-(void)setObjectValue:(id)v
{
}

-(float)floatValue
{
    return 0.0f;
}

-(int)intValue
{
    return (int)self.floatValue;
}

-(BOOL)boolValue
{
    return self.intValue != 0;
}

-(id)objectValue
{
    return nil;
}

-(BOOL)isHidden
{
    return hidden;
}

-(void)setHidden:(BOOL)b
{
    if (hidden != b)
    {
        hidden = b;
        [controller _prefToggledHidden:self];
    }
}

@end
