#import "BubblesPrefsController.h"
#import "BubblesCommon.h"

@implementation BubblesPrefsController
@synthesize rootViewController;

- (id)initWithDefaults:(BubblesSettings*)def
{
    if ((self = [super init]))
    {
        memcpy(&s, def, sizeof(BubblesSettings));
        [self loadPreferences];
    }
    return self;
}

- (void)savePreferences
{
    BubblesSaveSettings(&s);
}

- (void)loadPreferences
{
    BubblesLoadSettings(&s);
}

- (void)loadView
{
    CGRect f = [UIScreen mainScreen].bounds;
    UIImageView * bgView= [[UIImageView alloc] initWithFrame:f];
    self.view = bgView;
    bgView.autoresizesSubviews = YES;
    bgView.userInteractionEnabled = YES;
    bgView.image = [UIImage imageWithContentsOfFile:@LCRoot "Library/LivePapers/Plugins/Bubbles-rsrc/img/background.png"];

    UIView * v = bgView;
    float currentHeight = 30.0f;
    
    UILabel * label;

    UIScrollView * scroll = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGRect b = bgView.bounds;
        
        UINavigationBar * bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, b.size.width, 44)];
        UINavigationItem * barItem = [[UINavigationItem alloc] init];
        [bar pushNavigationItem:barItem animated:NO];
        bar.barStyle = UIBarStyleBlack;
        UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self.rootViewController
                                                 action:@selector(dismissPreferencesView)];
        barItem.rightBarButtonItem = button;
        [button release];
        [bgView addSubview: bar];
        [barItem release];
        [bar release];

        b.size.height -= 44;
        b.origin.y += 44;
        currentHeight -= 10;
        
        scroll = [[UIScrollView alloc] initWithFrame:b];
        scroll.clipsToBounds = YES;
        [bgView addSubview:scroll];
        v = scroll;
    }
    
#define addlabel(txt, off) \
    label = [[UILabel alloc] initWithFrame: CGRectMake(30, currentHeight + off, f.size.width - 160, 30)]; \
    label.text = txt; \
    label.backgroundColor = [UIColor clearColor]; \
    label.textColor = [UIColor whiteColor]; \
    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth; \
    [v addSubview:label]; \
    [label release]; \
    
#define segmentedpref(txt, var, text1, text2) \
    addlabel(txt, 5.0) \
    \
    var ## Segmented = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:text1, text2, nil]]; \
    var ## Segmented.selectedSegmentIndex = s.var; \
    [var ## Segmented addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged]; \
    [v addSubview:var ## Segmented]; \
    var ## Segmented.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin; \
    { \
        CGRect r = var ## Segmented.frame; \
        var ## Segmented.frame = CGRectMake(f.size.width - 30 - r.size.width, currentHeight, r.size.width, r.size.height); \
        currentHeight += r.size.height + 15.0; \
    } \
    

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

#define colorH 40.0
#define addcolor(off, colorW, r, g, b, tg) \
    { \
        LPColorWheel * vv = [[LPColorWheel alloc] initWithFrame: CGRectMake(f.size.width - off - colorW, currentHeight, colorW, colorH)]; \
        vv.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0]; \
        vv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin; \
        vv.tag = tg; \
        vv.delegate = self; \
        [v addSubview:vv]; \
        [vv release]; \
    }
    
    segmentedpref(@"Background", bgType, @"Default", @"Custom");
    addlabel(@"Custom Colors", 5.0f);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        addcolor(130, 80, s.r, s.g, s.b, 0);
        addcolor(30, 80, s.rs, s.gs, s.bs, 1);
    } else {
        addcolor(105, 60, s.r, s.g, s.b, 0);
        addcolor(30, 60, s.rs, s.gs, s.bs, 1);
    }
    currentHeight += colorH + 10.0;
    sliderpref(@"Particle Count", particleCount, 0, 300);
    sliderpref(@"Particle Lifetime", particleLifetime, 0.1, 30.0);
    sliderpref(@"Particle Size", particleSize, 0, 2.0);
    sliderpref(@"Particle Opacity", particleAlpha, 0.0, 1.0);
    sliderpref(@"Velocity", velocityMagnitude, 0, 3.0);
    sliderpref(@"Minimum Depth", minimumDepth, 0, 1.0);
    sliderpref(@"Maximum Depth", maximumDepth, 0, 1.0);
    segmentedpref(@"Touch action", swirl, @"Push", @"Swirl");
    segmentedpref(@"Particle Edge", sharpEdges, @"Blurry", @"Sharp");
    
    scroll.contentSize = CGSizeMake(scroll.bounds.size.width, currentHeight + 30.0);
    
    [self valueChanged:NULL];
    
    [bgView release];
    [scroll release];
}

- (void)colorWheel:(LPColorWheel*)wheel changedColor:(UIColor*)color
{
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    switch(wheel.tag)
    {
        case 0:
            s.r = r;
            s.g = g;
            s.b = b;
            break;
        case 1:
            s.rs = r;
            s.gs = g;
            s.bs = b;
            break;
    }
}

- (void)valueChanged:(NSObject*)sender
{
#define setlabel(var, format) if (sender == var ## Slider) s.var = var ## Slider.value; var ## Label.text = [NSString stringWithFormat:format, s.var]
#define setsegmented(var) if (sender == var ## Segmented) s.var = var ## Segmented.selectedSegmentIndex;
    setlabel(particleCount, @"%d");
    setlabel(particleLifetime, @"%.1f");
    setlabel(particleSize, @"%.3f");
    setlabel(particleAlpha, @"%.3f");
    setlabel(velocityMagnitude, @"%.3f");
    setlabel(minimumDepth, @"%.3f");
    setlabel(maximumDepth, @"%.3f");
    setsegmented(bgType);
    setsegmented(swirl);
    setsegmented(sharpEdges);
}

- (void)dealloc
{
    [particleCountSlider release];
    [particleLifetimeSlider release];
    [particleSizeSlider release];
    [velocityMagnitudeSlider release];
    [particleAlphaSlider release];
    [minimumDepthSlider release];
    [maximumDepthSlider release];
    [particleCountLabel release];
    [particleLifetimeLabel release];
    [particleSizeLabel release];
    [velocityMagnitudeLabel release];
    [particleAlphaLabel release];
    [minimumDepthLabel release];
    [maximumDepthLabel release];
    [bgTypeSegmented release];
    [swirlSegmented release];
    [sharpEdgesSegmented release];

    [super dealloc];
}

@end
