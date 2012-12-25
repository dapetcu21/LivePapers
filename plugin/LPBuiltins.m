#import <UIKit/UIKit.h>
#import "LPDefaultViewController.h"
#import "LPSolidViewController.h"
#import "LPSolidPrefsController.h"

UIViewController * LPInitViewController(NSObject * ud)
{
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

UIViewController * LPInitPrefsViewController(NSObject * ud)
{
    if ([ud isEqual:@"Solid"])
    {
        return [[LPSolidPrefsController alloc] init];
    }
    return nil;
}
