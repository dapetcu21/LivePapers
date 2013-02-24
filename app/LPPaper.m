#import "LPPaper.h"
#import "LPCommon.h"
#import "LPPreview.h"

@implementation LPPaper

@synthesize bundleID;
@synthesize name;
@synthesize plugin;
@synthesize userData;
@synthesize hasSettings;
@synthesize index;

- (id)initWithBundleID:(NSString*)path
{
    if ((self = [super init]))
    {
        @try {
            dict = [[NSDictionary dictionaryWithContentsOfFile:
                [NSString stringWithFormat:@"%@/%@/Info.plist", LCWallpapersPath, path]] retain];
            NSAssert(dict, @"No such file");
            bundleID = [path retain];
            name = [[NSString stringWithString:[dict objectForKey:@"Name"]] retain];
            plugin = [[NSString stringWithString:[dict objectForKey:@"Plugin"]] retain];
            userData = [[dict objectForKey:@"User Data"] retain];
            id hs = [dict objectForKey:@"Has Settings"];
            if ([hs isKindOfClass:[NSString class]] && [hs isEqualToString:@"Check"])
                hasSettings = [self.preview hasPreferences];
            else 
                hasSettings = [(NSNumber*)hs boolValue];
        } @catch(...) {
            [self release];
            return nil;
        }
    }
    return self;
}

- (UIImage*)image
{
    return image;
}

- (void)setImage:(UIImage*)img
{
    if (img == image) return;
    [img retain];
    [image release];
    image = img;
    
    if (img)
    {
        @try {
        NSData * data = UIImagePNGRepresentation(img);
        [data writeToFile:[LCIconCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.bundleID]] atomically:NO];
        } @catch(id ex) {
            NSLog(@"couldn't save thumbnail: %@", ex);
        }
    }
        
}

- (LPPreview*)preview
{
    if (!preview)
        preview = [[[LPPreview alloc] initWithPaper:self] autorelease];
    return preview;
}

- (void)dealloc
{
    preview.paper = nil;
    [image release];
    [dict release];
    [bundleID release];
    [name release];
    [plugin release];
    [userData release];
    [super dealloc];
}
@end
