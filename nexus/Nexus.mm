#import "NexusViewController.h"
#import "NexusPrefsController.h"

extern "C" {

UIViewController *  LPInitViewController(NSDictionary * info)
{
    NexusViewController * vc = [[NexusViewController alloc] init];
    vc.bundle = [NSBundle bundleWithPath:[info objectForKey:@"LCInitWallpaperPath"]];
    return vc;
}

UIViewController * LPInitPrefsViewController(NSDictionary * info)
{
    NexusPrefsController * vc = [[NexusPrefsController alloc] init];
    NSBundle * bundle = [NSBundle bundleWithPath:[info objectForKey:@"LCInitWallpaperPath"]];
    vc.image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"bg" ofType:@"png"]];
    return vc;
}

}
