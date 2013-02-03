#ifndef LPCOMMON_H
#define LPCOMMON_H

#if TARGET_IPHONE_SIMULATOR
#define LCVarMobile "/opt/theos/simroot/"
#define LCRoot "/opt/theos/simroot/"
#else
#define LCVarMobile "/var/mobile/"
#define LCRoot "/"
#endif

#define LCPrefsPath @LCVarMobile "Library/Preferences/org.porkholt.livepapers.plist"
#define LCDefaultPaper @"org.porkholt.livepapers.default"
#define LCPrefsHomeKey @"HomeWallpaper"
#define LCPrefsLockKey @"LockWallpaper"
#define LCCenterUDReloadItems @"ReloadItems"
#define LCCenterUDPrefsItems @"PrefsItems"
#define LCCenterName @"org.porkholt.livepapers.center"
#define LCCenterMessageReload @"reloadSettings"
#define LCCenterMessagePrefs @"reloadPreferences"
#define LCWallpapersPath @LCRoot "Library/LivePapers/Wallpapers"
#define LCPluginsPath @LCRoot "Library/LivePapers/Plugins"
#define LCBuiltinPrefsPath @LCVarMobile "Library/Preferences/org.porkholt.livepapers.builtinprefs.plist"
#define LCBuiltinPrefsSolidColor @"LCSolidColor"
#define LCBuiltinPrefsSolidColorDefaultRed   0.203f
#define LCBuiltinPrefsSolidColorDefaultGreen 0.325f
#define LCBuiltinPrefsSolidColorDefaultBlue  0.533f

#define LCInitName @"LCInitName"
#define LCInitBundleID @"LCInitBundleID"
#define LCInitUserData @"LCInitUserData"
#define LCInitWallpaperPath @"LCInitWallpaperPath"
#define LCInitIsPreview @"LCInitIsPreview"

#endif
