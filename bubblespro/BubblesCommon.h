struct BubblesSettings
{
    int bgType;
    float r,g,b;
    float rs,gs,bs;
    int particleCount;
    float particleLifetime, particleSize, velocityMagnitude, particleAlpha, minimumDepth, maximumDepth;
    bool swirl;
    bool sharpEdges;
};

extern "C" void BubblesLoadSettings(BubblesSettings * s);
extern "C" void BubblesSaveSettings(BubblesSettings * s);
extern "C" UIViewController * BubblesSettingsViewController(NSDictionary * initDict, BubblesSettings * defaults);

#if TARGET_IPHONE_SIMULATOR
#define LCVarMobile "/opt/theos/simroot/"
#define LCRoot "/opt/theos/simroot/"
#else
#define LCVarMobile "/var/mobile/"
#define LCRoot "/"
#endif

#define BBPrefsPath @LCVarMobile "Library/Preferences/org.porkholt.livepapers.bubbles.plist"
#define BKBgType @"BackgroundType"
#define BKRed @"BackgroundRed"
#define BKGreen @"BackgroundGreen"
#define BKBlue @"BackgroundBlue"
#define BKRedSec @"BackgroundRedSecondary"
#define BKGreenSec @"BackgroundGreenSecondary"
#define BKBlueSec @"BackgroundBlueSecondary"
#define BKCount @"ParticleCount"
#define BKLifeTime @"ParticleLifetime"
#define BKSize @"ParticleSize"
#define BKVelocity @"VelocityMagnitude"
#define BKAlpha @"ParticleAlpha"
#define BKDepth @"MinimumDepth"
#define BKDepthMax @"MaximumDepth"
#define BKSwirl @"Swirl"
#define BKSharp @"SharpEdges"

