#import "LPPlugin.h"
#import "LPController.h"
#import "LPCommon.h"
#include <dlfcn.h>

@implementation LPPlugin
@synthesize name;

-(id)initWithName:(NSString*)s
{
    if ((self = [super init])) 
    {
        name = [s retain];
        dlerror();
        NSString * libName = [NSString stringWithFormat:@"%@/%@.dylib", LCPluginsPath, name];
        lib = dlopen([libName UTF8String], RTLD_LAZY | RTLD_LOCAL);
        if (!lib)
        {
            [self release];
            @throw [NSException 
                exceptionWithName:@"LPDlopenException"
                reason: [NSString stringWithFormat:@"Cannot open %@: %s", libName, dlerror()]
                userInfo: nil];
        }
        fcn = dlsym(lib, "LPInitViewController");
        if (!fcn)
        {
            [self release];
            @throw [NSException 
                exceptionWithName:@"PLDlsymException"
                reason: [NSString stringWithFormat:@"Cannot find symbol \"LPInitViewController\" in %@: %s", libName, dlerror()]
                userInfo: nil];

        }
    }
    return self;
}

-(void)dealloc
{
    [[LPController sharedInstance] removePluginNamed:name];
    [name release];
    if (lib)
        dlclose(lib);
    [super dealloc];
}

-(UIViewController*)newViewController:(NSObject*)ud
{
    return fcn(ud);
}

@end
