#import "BubblesCommon.h"
#import "BubblesPrefsController.h"

extern "C" void BubblesLoadSettings(BubblesSettings * s)
{
    NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:BBPrefsPath];
    NSNumber * nr;
#define getparam(key, type, var) nr = [prefs objectForKey:key]; if([nr isKindOfClass:[NSNumber class]]) s->var = nr. type ## Value
    
    getparam(BKBgType, int, bgType);
    getparam(BKRed, float, r);
    getparam(BKGreen, float, g);
    getparam(BKBlue, float, b);
    getparam(BKRedSec, float, rs);
    getparam(BKGreenSec, float, gs);
    getparam(BKBlueSec, float, bs);
    getparam(BKCount, int, particleCount);
    getparam(BKLifeTime, float, particleLifetime);
    getparam(BKSize, float, particleSize);
    getparam(BKVelocity, float, velocityMagnitude);
    getparam(BKAlpha, float, particleAlpha);
    getparam(BKDepth, float, minimumDepth);
    getparam(BKDepthMax, float, maximumDepth);
    getparam(BKSwirl, bool, swirl);
    getparam(BKSharp, bool, sharpEdges);
}

extern "C" void BubblesSaveSettings(BubblesSettings * s)
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
#define setparam(key, type, value) [dict setObject:[NSNumber numberWith ## type:s->value] forKey:key]

    setparam(BKBgType, Int, bgType);
    setparam(BKRed, Float, r);
    setparam(BKGreen, Float, g);
    setparam(BKBlue, Float, b);
    setparam(BKRedSec, Float, rs);
    setparam(BKGreenSec, Float, gs);
    setparam(BKBlueSec, Float, bs);
    setparam(BKCount, Int, particleCount);
    setparam(BKLifeTime, Float, particleLifetime);
    setparam(BKSize, Float, particleSize);
    setparam(BKVelocity, Float, velocityMagnitude);
    setparam(BKAlpha, Float, particleAlpha);
    setparam(BKDepth, Float, minimumDepth);
    setparam(BKDepthMax, Float, maximumDepth);
    setparam(BKSwirl, Bool, swirl);
    setparam(BKSharp, Bool, sharpEdges);

    [dict writeToFile:BBPrefsPath atomically:YES];
    [dict release];
}

extern "C" UIViewController * BubblesSettingsViewController(NSDictionary * initDict, BubblesSettings * defaults)
{
    return [[BubblesPrefsController alloc] initWithDefaults:defaults];
}

