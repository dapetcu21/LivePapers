#import <UIKit/UIKit.h>
#import "LPDefaultViewController.h"
#import "LPDefaultPrefsController.h"
#import "LPSolidViewController.h"
#import "LPSolidPrefsController.h"

UIViewController * LPInitViewController(NSDictionary * info)
{
    NSString * ud = [info objectForKey:@"LCInitUserData"];
    if ([ud isEqual:@"Default"])
    {
        return [[LPDefaultViewController alloc] init];
    }
    if ([ud isEqual:@"Solid"])
    {
        return [[LPSolidViewController alloc] init];
    }
    return nil;
}

UIViewController * LPInitPrefsViewController(NSDictionary * info)
{
    NSString * ud = [info objectForKey:@"LCInitUserData"];
    if ([ud isEqual:@"Solid"])
    {
        return [[LPSolidPrefsController alloc] init];
    }
    if ([ud isEqual:@"Default"])
    {
        return [[LPDefaultPrefsController alloc] init];
    }
    return nil;
}
