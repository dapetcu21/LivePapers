#ifndef LPCOMMON_H
#define LPCOMMON_H

#import <UIKit/UIKit.h>
#include <stdarg.h>

#if TARGET_IPHONE_SIMULATOR
#define LCVarMobile "/opt/theos/simroot/"
#define LCRoot "/opt/theos/simroot/"
#else
#define LCVarMobile "/var/mobile/"
#define LCRoot "/"
#endif

#define LCPrefsPath @LCVarMobile "Library/Preferences/org.porkholt.livepapers.plist"
#define LCCydiaURL @"cydia://search/LivePapers"
#define LCDefaultPaper @"org.porkholt.livepapers.default"
#define LCPrefsHomeKey @"HomeWallpaper"
#define LCPrefsLockKey @"LockWallpaper"
#define LCPrefsInterHome @"InteractionHome"
#define LCPrefsInterLock @"InteractionLock"
#define LCPrefsOverlayAlpha @"AltImageAlpha"
#define LCPrefsIdleTimeout @"IdleTimeout"
#define LCPrefsPauseOnNC @"PauseOnNC"
#define LCPrefsUndimSpotlight @"UndimSpotlight"
#define LCPrefsBlackCharging @"BlackCharging"
#define LCPrefsNotifLastUpdate @"NotifLastUpdate"
#define LCPrefsNotifCount @"NotifCount"
#define LCCenterUDReloadItems @"ReloadItems"
#define LCCenterUDPrefsItems @"PrefsItems"
#define LCCenterName @"org.porkholt.livepapers.center"
#define LCCenterMessageReload @"reloadSettings"
#define LCCenterMessagePrefs @"reloadPreferences"
#define LCWallpapersPath @LCRoot "Library/LivePapers/Wallpapers"
//#define LCIconCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define LCIconCachePath @LCVarMobile "Library/Caches/org.porkholt.LivePapers/Thumbnails"
#define LCPluginsPath @LCRoot "Library/LivePapers/Plugins"
#define LCBuiltinPrefsPath @LCVarMobile "Library/Preferences/org.porkholt.livepapers.builtinprefs.plist"
#define LCBuiltinPrefsSolidColor @"LCSolidColor"
#define LCBuiltinPrefsSolidColorDefaultRed   0.203f
#define LCBuiltinPrefsSolidColorDefaultGreen 0.325f
#define LCBuiltinPrefsSolidColorDefaultBlue  0.533f
#define LCBuiltinPrefsGradientAlpha @"LCGradientAlpha"

#define LCInitName @"LCInitName"
#define LCInitBundleID @"LCInitBundleID"
#define LCInitUserData @"LCInitUserData"
#define LCInitWallpaperPath @"LCInitWallpaperPath"
#define LCInitPluginPath @"LCInitPluginPath"
#define LCInitIsPreview @"LCInitIsPreview"

inline void LPAlertLog(NSString * format, ...)
{
    va_list args;
    va_start(args, format);
    NSString * s = [[NSString alloc] initWithFormat:format arguments:args]; 
    va_end(args);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LivePapers" message:s delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil ];
    [alert show];
    [alert release];

    [s release];
}

#endif
