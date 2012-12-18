#import "LPPaper.h"

@implementation LPPaper

@synthesize bundleID;
@synthesize name;
@synthesize plugin;
@synthesize userData;
@synthesize hasSettings;

- (id)initWithBundleID:(NSString*)path
{
    if ((self = [super init]))
    {
        dict = [[NSDictionary dictionaryWithContentsOfFile:
            [NSString stringWithFormat:@"/Library/LivePapers/Wallpapers/%@/Info.plist", path]] retain];
        bundleID = [path retain];
        name = [[NSString stringWithString:[dict objectForKey:@"Name"]] retain];
        plugin = [[NSString stringWithString:[dict objectForKey:@"Plugin"]] retain];
        userData = [[dict objectForKey:@"User Data"] retain];
        hasSettings = [(NSNumber*)[dict objectForKey:@"Has Settings"] boolValue];

        NSLog(@"hasSettings %d", hasSettings);
        if (!dict || !plugin || !name)
        {
            [self release];
            return nil;
        }
    }
    return self;
}

- (void)dealloc
{
    [dict release];
    [bundleID release];
    [name release];
    [plugin release];
    [userData release];
    [super dealloc];
}
@end
