#ifndef NEXUSCOMMON_H
#define NEXUSCOMMON_H

#if TARGET_IPHONE_SIMULATOR
#define LCVarMobile "/opt/theos/simroot/"
#define LCRoot "/opt/theos/simroot/"
#else
#define LCVarMobile "/var/mobile/"
#define LCRoot "/"
#endif

#define NXPrefsPath @LCVarMobile "Library/Preferences/org.porkholt.livepapers.nexus.plist"
#define NXWallKey @"UseWallpaper"
#define NXLengthKey @"StripLength"
#define NXWidthKey @"StripWidth"
#define NXVelocityKey @"StripVelocity"
#define NXZToleranceKey @"ZTolerance"
#define NXCountKey @"StripCount"

#endif
