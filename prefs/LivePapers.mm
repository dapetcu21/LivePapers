#import <Preferences/Preferences.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import "LPCommon.h"

@interface LPListController: PSListController {
}
@end

@implementation LPListController
-(id)specifiers
{
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"LivePapers" target:self] retain];
	}
	return _specifiers;
}

-(void)suspend
{
    [super suspend];
    [[CPDistributedMessagingCenter centerNamed:LCCenterName] sendMessageName:LCCenterMessageReload userInfo:nil];
}
@end

