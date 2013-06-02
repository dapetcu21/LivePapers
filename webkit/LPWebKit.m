#import <UIKit/UIKit.h>
#import "LPWebKitController.h"

UIViewController * LPInitViewController(NSDictionary * info)
{
    NSURL * url = nil;

    NSDictionary * ud = [info objectForKey:@"LCInitUserData"];
    if (ud && [ud isKindOfClass:[NSDictionary class]])
    {
        NSString * s = [ud objectForKey:@"URL"];
        if (s && [s isKindOfClass:[NSString class]])
           url = [NSURL URLWithString:s];
    }

    if (!url)
    {
        NSString * s = [info objectForKey:@"LCInitWallpaperPath"];
        if (s && [s isKindOfClass:[NSString class]])
            url = [NSURL fileURLWithPath:[s stringByAppendingPathComponent:@"index.html"]];
    }
    
    if (!url)
        return nil;

    LPWebKitController * vc = [[LPWebKitController alloc] init];
    vc.url = url;
    return vc;
}

UIViewController * LPInitPrefsViewController(NSDictionary * info)
{
    NSURL * url = nil;

    NSDictionary * ud = [info objectForKey:@"LCInitUserData"];
    if (ud && [ud isKindOfClass:[NSDictionary class]])
    {
        NSString * s = [ud objectForKey:@"Configure URL"];
        if (s && [s isKindOfClass:[NSString class]])
           url = [NSURL URLWithString:s];
    }

    if (!url)
    {
        NSString * s = [info objectForKey:@"LCInitWallpaperPath"];
        if (s && [s isKindOfClass:[NSString class]])
            url = [NSURL fileURLWithPath:[s stringByAppendingPathComponent:@"configure.html"]];
    }

    if (!url)
        return nil;

    LPWebKitController * vc = [[LPWebKitController alloc] init];
    vc.url = url;
    return vc;
}
