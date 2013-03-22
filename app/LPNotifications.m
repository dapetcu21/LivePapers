#import "LPNotifications.h"
#import "LPCommon.h"

@interface LPAlertDelegate : NSObject<UIAlertViewDelegate>
@end
@implementation LPAlertDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: LCCydiaURL]];
    [self release];
}
@end

void LPListenForNotifications()
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    long long tm = [defaults doubleForKey:LCPrefsNotifLastUpdate];
    NSInteger count = [defaults integerForKey:LCPrefsNotifCount];

    long long tim = time(NULL);
    if (abs(tm-tim) > 3600)
    {
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://porkholt.shark0der.com/version.js"]] queue:[NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse * response, NSData * data, NSError * error) {
            if (!error)
            {
                NSString * s = [NSString stringWithUTF8String:[data bytes]];
                NSInteger c = [s integerValue];
                if (c != count)
                {   
                    LPAlertDelegate * delegate = [[LPAlertDelegate alloc] init];
                    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"New Livepapers" message:@"We just wanted to let you know that we released some awesome new live wallpapers. Go check them out in Cydia." delegate:delegate cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yeah", nil] autorelease];
                    [alert show];
                }
                [defaults setDouble:(double)tim forKey:LCPrefsNotifLastUpdate];
                [defaults setInteger:c forKey:LCPrefsNotifCount];
                [defaults synchronize];
            }
        }];
    }
}
