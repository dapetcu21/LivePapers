#import "NexusPrefsController.h"
#import "NexusCommon.h"

@implementation NexusPrefsController
@synthesize image;
@synthesize colors;
@synthesize rootViewController;

- (void)loadView
{
    CGRect f = [UIScreen mainScreen].bounds;
    UIImageView * v = [[UIImageView alloc] initWithFrame:f];
    self.view = v;
    v.autoresizesSubviews = YES;
    v.userInteractionEnabled = YES;
    v.image = self.image;
    self.image = nil;
    
    float currentHeight = 15; 

    UILabel * label = [[UILabel alloc] initWithFrame:
        CGRectMake(30, currentHeight, f.size.width - 60, 30)];
    label.text = @"Use my wallpaper";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [v addSubview:label];
    [label release];

    [self loadPreferences];

    UISwitch * sw = [[UISwitch alloc] initWithFrame:
        CGRectMake(f.size.width - 60 - 50, currentHeight + 2, 95, 27)];
    sw.on = wallpaper;
    sw.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [sw addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [v addSubview:sw];
    [sw release];
    
    currentHeight+= 40;

#define sliderpref(txt, var, minV, maxV) \
    label = [[UILabel alloc] initWithFrame: CGRectMake(30, currentHeight, f.size.width - 160, 30)]; \
    label.text = txt; \
    label.backgroundColor = [UIColor clearColor]; \
    label.textColor = [UIColor whiteColor]; \
    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth; \
    [v addSubview:label]; \
    [label release]; \
    \
    var ## Label = [[UILabel alloc] initWithFrame: CGRectMake(f.size.width - 130, currentHeight, 95, 30)]; \
    var ## Label.backgroundColor = [UIColor clearColor]; \
    var ## Label.textColor = [UIColor whiteColor]; \
    var ## Label.textAlignment = NSTextAlignmentRight; \
    var ## Label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin; \
    [v addSubview:var ## Label]; \
    currentHeight+= 30; \
    \
    var ## Slider = [[UISlider alloc] initWithFrame: CGRectMake(30, currentHeight, f.size.width - 60, 30)]; \
    var ## Slider.minimumValue = minV; \
    var ## Slider.maximumValue = maxV; \
    var ## Slider.value = var; \
    var ## Slider.continuous = YES; \
    var ## Slider.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth; \
    [var ## Slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged]; \
    [v addSubview:var ## Slider]; \
    currentHeight+= 35

    sliderpref(@"Strip width", width, 0.0f, 0.15f);
    sliderpref(@"Strip length", length, 0.0f, 1.5f);
    sliderpref(@"Velocity", velocity, 0.1f, 1.5f);
    sliderpref(@"Depth tolerance", zTolerance, 0.0f, 1.5f);
    sliderpref(@"Strip count", count, 1, 50);

#define colorBorder 30
#define colorHeight 40
#define colorFraction 0.1
    currentHeight+= 15;
    UIView * colorContainer = [[UIView alloc] initWithFrame: CGRectMake(colorBorder, currentHeight, f.size.width - 2*colorBorder, colorHeight)];
    currentHeight+= colorHeight;
    colorContainer.autoresizesSubviews = YES;
    colorContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    
    float blockWidth = colorContainer.bounds.size.width / (4 + 3*colorFraction);
    for (int i = 0; i < 4; i++)
    {
        LPColorWheel * w = [[LPColorWheel alloc] initWithFrame: CGRectMake(i * (blockWidth * (1 + colorFraction)), 0, blockWidth, colorHeight)];
        w.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        w.backgroundColor = [colors objectAtIndex:i];
        w.tag = i;
        w.delegate = self;
        [colorContainer addSubview:w];
        [w release];
    }
    [v addSubview: colorContainer];
    [colorContainer release];

    [self valueChanged:NULL];
    [v release];
}

- (void)colorWheel:(LPColorWheel*)wheel changedColor:(UIColor*)color
{
    [colors replaceObjectAtIndex:wheel.tag withObject:color];
}

- (void)sliderValueChanged:(UISwitch*)sender
{
    wallpaper = sender.on;
}

- (void)valueChanged:(NSObject*)sender
{
#define setlabel(var, format) if (sender == var ## Slider) var = var ## Slider.value; var ## Label.text = [NSString stringWithFormat:format, var]
    setlabel(width, @"%.3f");
    setlabel(length, @"%.2f");
    setlabel(velocity, @"%.2f");
    setlabel(zTolerance, @"%.2f");
    setlabel(count, @"%zu");
}

- (void)dealloc
{
    [countLabel release];
    [lengthLabel release];
    [widthLabel release];
    [velocityLabel release];
    [zToleranceLabel release];

    [countSlider release];
    [lengthSlider release];
    [widthSlider release];
    [velocitySlider release];
    [zToleranceSlider release];
    
    [colors release];
    [rootViewController release];

    [super dealloc];
}

- (void)loadPreferences
{
    NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:NXPrefsPath];

    NSNumber * nr;
#define getparam(key, type, var, def) nr = [prefs objectForKey:key]; if([nr isKindOfClass:[NSNumber class]]) var = nr. type ## Value; else var = def
    getparam(NXWallKey,       bool, wallpaper, NO);
    getparam(NXLengthKey,     float, length, 0.6f);
    getparam(NXWidthKey,      float, width, 0.035f);
    getparam(NXVelocityKey,   float, velocity, 0.4f);
    getparam(NXZToleranceKey, float, zTolerance, 0.5f);
    getparam(NXCountKey,      int, count, 10);
    
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    UIColor * particle_colors[4] = {
        UIColorFromRGB(0xff9f00),
        UIColorFromRGB(0xff0000),
        UIColorFromRGB(0x00ff00),
        UIColorFromRGB(0x0000ff)
    };
    
    float v[12];
    NSArray * a = [prefs objectForKey:NXColorsKey];
    if (!a || ![a isKindOfClass:[NSArray class]])
        goto error;
    
    for (int i = 0; i < 12; i++)
    { 
        NSNumber * nr = (NSNumber*)[a objectAtIndex:i];
        if (!nr || ![nr isKindOfClass:[NSNumber class]])
            goto error;
        v[i] = nr.floatValue;
    }
    
    particle_colors[0] = [UIColor colorWithRed:v[0] green:v[1] blue:v[2] alpha:1.0];
    particle_colors[1] = [UIColor colorWithRed:v[3] green:v[4] blue:v[5] alpha:1.0];
    particle_colors[2] = [UIColor colorWithRed:v[6] green:v[7] blue:v[8] alpha:1.0];
    particle_colors[3] = [UIColor colorWithRed:v[9] green:v[10] blue:v[11] alpha:1.0];

    error:
    self.colors = [NSMutableArray arrayWithObjects: particle_colors[0], particle_colors[1], particle_colors[2], particle_colors[3], nil];
}

- (void)savePreferences
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];

#define setparam(key, type, value) [dict setObject:[NSNumber numberWith ## type:value] forKey:key]
    setparam(NXWallKey,       Bool, wallpaper);
    setparam(NXLengthKey,     Float, length);
    setparam(NXWidthKey,      Float, width);
    setparam(NXVelocityKey,   Float, velocity);
    setparam(NXZToleranceKey, Float, zTolerance);
    setparam(NXCountKey,      Int, count);
       
    CGFloat fv[12], discard;
    [(UIColor*)[colors objectAtIndex:0] getRed:fv + 0 green:fv + 1 blue:fv + 2 alpha:&discard];
    [(UIColor*)[colors objectAtIndex:1] getRed:fv + 3 green:fv + 4 blue:fv + 5 alpha:&discard];
    [(UIColor*)[colors objectAtIndex:2] getRed:fv + 6 green:fv + 7 blue:fv + 8 alpha:&discard];
    [(UIColor*)[colors objectAtIndex:3] getRed:fv + 9 green:fv +10 blue:fv +11 alpha:&discard];
    
    [dict setObject:[NSArray arrayWithObjects:
        [NSNumber numberWithFloat:fv[0]],
        [NSNumber numberWithFloat:fv[1]],
        [NSNumber numberWithFloat:fv[2]],

        [NSNumber numberWithFloat:fv[3]],
        [NSNumber numberWithFloat:fv[4]],
        [NSNumber numberWithFloat:fv[5]],

        [NSNumber numberWithFloat:fv[6]],
        [NSNumber numberWithFloat:fv[7]],
        [NSNumber numberWithFloat:fv[8]],

        [NSNumber numberWithFloat:fv[9]],
        [NSNumber numberWithFloat:fv[10]],
        [NSNumber numberWithFloat:fv[11]],
        
    nil] forKey:NXColorsKey];

    [dict writeToFile:NXPrefsPath atomically:YES];
    [dict release];
}


@end
