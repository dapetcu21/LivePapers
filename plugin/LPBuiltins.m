#import <UIKit/UIKit.h>
#import "LPDefaultViewController.h"

UIViewController * LPInitViewController(NSObject * ud)
{
    if ([ud isEqual:@"Default"])
    {
        return [[LPDefaultViewController alloc] init];
    }
    return nil;
}
