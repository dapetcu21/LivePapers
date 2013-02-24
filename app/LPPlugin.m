#import "LPPlugin.h"
#import "LPCommon.h"
#include <dlfcn.h>

@implementation LPPlugin

- (id)initWithName:(NSString*)name
{
    if ((self = [super init]))
    {
        NSString * path = [NSString stringWithFormat:@"%@/%@.dylib", LCPluginsPath, name];
        handle = dlopen([path UTF8String], RTLD_LAZY | RTLD_LOCAL);
        if (!handle)
        {
            [self release];
            @throw [NSException 
                exceptionWithName:@"LPDlopenException"
                reason: [NSString stringWithFormat:@"Cannot open %@: %s", path, dlerror()]
                userInfo: nil];
        }
        vcFunction = dlsym(handle, "LPInitViewController");
        if (!vcFunction)
        {
            [self release];
            @throw [NSException 
                exceptionWithName:@"PLDlsymException"
                reason: [NSString stringWithFormat:@"Cannot find symbol \"LPInitViewController\" in %@: %s", path, dlerror()]
                userInfo: nil];
        }
        prefsFunction = dlsym(handle, "LPInitPrefsViewController");
        hasPrefsFunction = dlsym(handle, "LPInitPrefsViewController");
    }
    return self;
}

- (void)dealloc
{
    if (handle)
        dlclose(handle);
    [super dealloc];
}

- (UIViewController*)viewControllerWithUserInfo:(void*)userInfo
{
    return vcFunction(userInfo);
}

- (UIViewController*)preferencesViewControllerWithUserInfo:(void*)userInfo
{
    if (!prefsFunction) return nil;
    return prefsFunction(userInfo);
}

- (BOOL)hasPreferences:(void*)userInfo
{
    if (!hasPrefsFunction) return NO;
    return hasPrefsFunction(userInfo) != 0;
}


@end
