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
        NSArray * specifiers = [self loadSpecifiersFromPlistName:@"LivePapers" target:self];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            specifiers = [specifiers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^(PSSpecifier * obj, NSDictionary * bindings) {
                return (BOOL)![obj.name isEqual:@"Blackout while charging"];
            }]];
        _specifiers = [specifiers retain];
	}
	return _specifiers;
}

-(void)suspend
{
    [super suspend];
    [[CPDistributedMessagingCenter centerNamed:LCCenterName] sendMessageName:LCCenterMessageReload userInfo:nil];
}
@end

