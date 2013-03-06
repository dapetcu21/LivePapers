#import "LPDefaultPrefsController.h"
#import "LPCommon.h"

@implementation LPDefaultPrefsController

- (void)loadPreferences
{
    LPDefaultLoadPrefs(&s);
}

- (void)savePreferences
{
    LPDefaultSavePrefs(&s);
}

- (void)loadView
{
    CGRect f = [UIScreen mainScreen].bounds;
    UIView * bgView = [[UIView alloc] initWithFrame:f];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.autoresizesSubviews = YES;
    bgView.userInteractionEnabled = YES;
    self.view = bgView;
    [bgView release];

    UIView * v = bgView;
    UILabel * label;
    float currentHeight = 30.0f;
    
    [self loadPreferences];

#define addlabel(txt, off) \
    label = [[UILabel alloc] initWithFrame: CGRectMake(30, currentHeight + (off), f.size.width - 160, 30)]; \
    label.text = txt; \
    label.backgroundColor = [UIColor clearColor]; \
    label.textColor = [UIColor whiteColor]; \
    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth; \
    [v addSubview:label]; \
    [label release]; \

#define sliderpref(txt, var, minV, maxV) \
    addlabel(txt, 0.0) \
    \
    var ## Label = [[UILabel alloc] initWithFrame: CGRectMake(f.size.width - 130, currentHeight, 100, 30)]; \
    var ## Label.backgroundColor = [UIColor clearColor]; \
    var ## Label.textColor = [UIColor whiteColor]; \
    var ## Label.textAlignment = NSTextAlignmentRight; \
    var ## Label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin; \
    [v addSubview:var ## Label]; \
    \
    currentHeight += 30.0f;\
    \
    var ## Slider = [[UISlider alloc] initWithFrame: CGRectMake(30, currentHeight, f.size.width - 60, 30)]; \
    var ## Slider.minimumValue = minV; \
    var ## Slider.maximumValue = maxV; \
    var ## Slider.value = s.var; \
    var ## Slider.continuous = YES; \
    var ## Slider.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth; \
    [var ## Slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged]; \
    [v addSubview:var ## Slider]; \
    \
    currentHeight += 30.0f

    sliderpref(@"Gradient opacity", gradientAlpha, 0.0, 1.0);
    
    [self valueChanged:NULL];
}

- (void)valueChanged:(NSObject*)sender
{
#define setlabel(var, format) if (sender == var ## Slider) s.var = var ## Slider.value; var ## Label.text = [NSString stringWithFormat:format, s.var]
    setlabel(gradientAlpha, @"%.2f");
}

- (void)dealloc
{
    [gradientAlphaSlider release];
    [gradientAlphaLabel release];
    [super dealloc];
}

@end

void LPDefaultSavePrefs(struct LPDefaultPrefs * s)
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:LCBuiltinPrefsPath];
    if (!dict)
        dict = [NSMutableDictionary dictionary];
#define setparam(key, type, value) [dict setObject:[NSNumber numberWith ## type:s->value] forKey:key]
    
    setparam(LCBuiltinPrefsGradientAlpha, Float, gradientAlpha);
    
    [dict writeToFile:LCBuiltinPrefsPath atomically:YES];
}

void LPDefaultLoadPrefs(struct LPDefaultPrefs * s)
{
    s->gradientAlpha = 1.0f;
    
    NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:LCBuiltinPrefsPath];
    NSNumber * nr;
#define getparam(key, type, var) nr = [prefs objectForKey:key]; if([nr isKindOfClass:[NSNumber class]]) s->var = nr. type ## Value
 
    getparam(LCBuiltinPrefsGradientAlpha, float, gradientAlpha);
}


