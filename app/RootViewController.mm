#import "RootViewController.h"
#import "LPPaper.h"
#import "AFOpenFlowView.h"
#import "LPCommon.h"
#import <AppSupport/CPDistributedMessagingCenter.h>


@implementation RootViewController
- (void)loadView {
    [self loadPapers];
    defaultImage = [[UIImage imageNamed:@"placeholder"] retain];

    CGRect r = [[UIScreen mainScreen] applicationFrame];
    UIImageView * view = [[[UIImageView alloc] initWithFrame:r] autorelease];
    view.userInteractionEnabled = YES;
    view.image = [UIImage imageNamed:@"background"];
    self.view = view;

    flowView = [[AFOpenFlowView alloc] initWithFrame:view.bounds];
    CGFloat s = r.size.height * 0.7;
    flowView.coverImageSize = s;
    flowView.sideCoverZPosition = -150;
    flowView.sideOffset = 50;
    flowView.coverSpacing = 300;
    flowView.dragDivisor = 0.9;
    flowView.coverHeightOffset = 0;
    flowView.dataSource = self;
    flowView.viewDelegate = self;
    [self.view addSubview:flowView];

    bar = [[UIImageView alloc] initWithFrame:CGRectMake(view.bounds.origin.x, view.bounds.origin.y, r.size.width, 60)];
    bar.image = [UIImage imageNamed:@"bar"];
    bar.userInteractionEnabled = YES;
    [flowView addSubview:bar];

    container = [[UIView alloc] initWithFrame:bar.bounds];
    [bar addSubview:container];


    label = [[UILabel alloc] initWithFrame:container.bounds];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20.0f];
    [label setBackgroundColor:[UIColor clearColor]];
    label.text = @"<No Wallpapers>";
    [container addSubview:label];

    homeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    homeButton.frame = CGRectMake(10, 10, 40, 40);
    [homeButton setBackgroundImage:[UIImage imageNamed:@"home_up"] forState:UIControlStateNormal];
    [homeButton setBackgroundImage:[UIImage imageNamed:@"home_down"] forState:UIControlStateHighlighted];
    [homeButton addTarget:self action:@selector(setHome) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:homeButton];

    lockButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    lockButton.frame = CGRectMake(55, 10, 40, 40);
    [lockButton setBackgroundImage:[UIImage imageNamed:@"lock_up"] forState:UIControlStateNormal];
    [lockButton setBackgroundImage:[UIImage imageNamed:@"lock_down"] forState:UIControlStateHighlighted];
    [lockButton addTarget:self action:@selector(setLock) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:lockButton];

    settingsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    settingsButton.frame = CGRectMake(r.size.width - 50, 10, 40, 40);
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"settings_up"] forState:UIControlStateNormal];
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"settings_down"] forState:UIControlStateHighlighted];
    [container addSubview:settingsButton];

    homeBadge = [[UIImageView alloc] initWithFrame:CGRectMake(30, -10, 20, 20)];
    homeBadge.image = [UIImage imageNamed:@"home_badge"];
    [homeButton addSubview:homeBadge];

    lockBadge = [[UIImageView alloc] initWithFrame:CGRectMake(30, -10, 20, 20)];
    lockBadge.image = [UIImage imageNamed:@"lock_badge"];
    [lockButton addSubview:lockBadge];

    if ([papers count])
        [self selectedPaper:(LPPaper*)[papers objectAtIndex:0]];
}

- (void)setHome
{
    NSUInteger index = flowView.selectedCoverView.number;
    if (index < [papers count])
    {
        LPPaper * paper = (LPPaper*)[papers objectAtIndex:index];
        NSString * s = [paper.bundleID retain];
        [homePaper release];
        homePaper = s;
        [self selectedPaper:paper]; 
    }
    [self saveSettings:LCPrefsHomeKey];
}

- (void)setLock
{
    NSUInteger index = flowView.selectedCoverView.number;
    if ((NSUInteger)index < [papers count])
    {
        LPPaper * paper = (LPPaper*)[papers objectAtIndex:index];
        NSString * s = [paper.bundleID retain];
        [lockPaper release];
        lockPaper = s;
        [self selectedPaper:paper];
    }
    [self saveSettings:LCPrefsLockKey];
}

- (void)selectedPaper:(LPPaper*)p
{
    if (p)
    {
        label.text = p.name;
        homeBadge.hidden = !([homePaper isEqual:p.bundleID]);
        lockBadge.hidden = !([lockPaper isEqual:p.bundleID]);
        settingsButton.hidden = !p.hasSettings;
        homeButton.hidden = NO;
        lockButton.hidden = NO;
    } else {
        label.text = @"Get more wallpapers...";
        homeBadge.hidden = YES;
        lockBadge.hidden = YES;
        settingsButton.hidden = YES;
        homeButton.hidden = YES;
        lockButton.hidden = YES;
    }
}

- (void)loadPapers {
    if (papers)
        [papers release];
    papers = [[NSMutableArray alloc] init];
    
    NSArray *dirContents = [[NSFileManager defaultManager] 
                            contentsOfDirectoryAtPath:LCWallpapersPath error:nil];
    for (NSString * path in dirContents)
    {
        LPPaper * paper = [[[LPPaper alloc] initWithBundleID:path] autorelease];
        if (paper)
            [papers addObject:paper];
    }

    NSDictionary * sett = [NSDictionary dictionaryWithContentsOfFile: LCPrefsPath];
    NSString * p = (NSString*)[sett objectForKey:LCPrefsHomeKey];
    if (![p isKindOfClass:[NSString class]])
        p = LCDefaultPaper;
    homePaper = [p retain];
    p = (NSString*)[sett objectForKey:LCPrefsLockKey];
    if (![p isKindOfClass:[NSString class]])
        p = LCDefaultPaper;
    lockPaper = [p retain];
}

-(void)saveSettings:(NSString*)s
{
    NSDictionary * sett = [NSDictionary dictionaryWithObjectsAndKeys:
        homePaper, LCPrefsHomeKey,
        lockPaper, LCPrefsLockKey,
        nil];
    [sett writeToFile: LCPrefsPath atomically:YES];
    NSDictionary * ud = nil;
    if (s)
        ud = [NSDictionary dictionaryWithObjectsAndKeys:
            s, LCCenterUDReloadItems, nil];
    [[CPDistributedMessagingCenter centerNamed:LCCenterName] sendMessageName:LCCenterMessageReload userInfo:ud];
}


- (NSInteger) numberOfImagesInOpenView:(AFOpenFlowView *)openFlowView
{
    return [papers count] + 1;
}


- (UIImage *)defaultImage
{
    return defaultImage;
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView requestImageForIndex:(NSInteger)index
{
}

- (void)openFlowViewScrollingDidBegin:(AFOpenFlowView *)openFlowView
{
    [UIView beginAnimations:@"meow" context:nil];
    [UIView setAnimationDuration:0.25];
    [label setAlpha:0];
    [UIView commitAnimations];
}

- (void)openFlowViewScrollingDidEnd:(AFOpenFlowView *)openFlowView
{
    [UIView beginAnimations:@"meow" context:nil];
    [UIView setAnimationDuration:0.25];
    [label setAlpha:1];
    [UIView commitAnimations];
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(NSInteger)index
{
    LPPaper * paper = nil;
    if ((NSUInteger)index < [papers count])
        paper = (LPPaper*)[papers objectAtIndex:index];
    [self selectedPaper:paper];
}

- (void)dealloc {
    [flowView release];
    [background release];
    [papers release];
    [defaultImage release];
    [label release];
    [bar release];
    [homeButton release];
    [lockButton release];
    [settingsButton release];
    [homePaper release];
    [lockPaper release];
    [lockBadge release];
    [homeBadge release];
    [container release];
    [super dealloc];
}
@end
