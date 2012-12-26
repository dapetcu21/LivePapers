#import "LPRootViewController.h"
#import "LPPaper.h"
#import "LPPreview.h"
#import "AFOpenFlowView.h"
#import "LPCommon.h"
#import "LPPreviewView.h"
#import <AppSupport/CPDistributedMessagingCenter.h>


@implementation LPRootViewController
- (void)loadView {
    [self loadPapers];
    defaultImage = [[UIImage imageNamed:@"placeholder"] retain];
    moreImage = [[UIImage imageNamed:@"more"] retain];

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
//    flowView.coverSpacing = 300;
    flowView.dragDivisor = 3;
    flowView.coverHeightOffset = 0;
    flowView.dataSource = self;
    flowView.viewDelegate = self;
    [self.view addSubview:flowView];

    bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(view.bounds.origin.x, view.bounds.origin.y, r.size.width, 44)];
    [flowView addSubview:bar];
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    if (!iPad)
        bar.barStyle = UIBarStyleBlack;

    barItem = [[UINavigationItem alloc] init];
    [bar pushNavigationItem:barItem animated:NO];

    homeButton = [[UIBarButtonItem alloc] initWithTitle:iPad?@"Set Home":@"Home"
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(setHome)];

    lockButton = [[UIBarButtonItem alloc] initWithTitle:iPad?@"Set Lock":@"Lock"
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(setLock)];



    settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Configure"
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                    action:@selector(configurePaper)];

    barItem.leftBarButtonItems = [NSArray arrayWithObjects:homeButton, lockButton, nil];
    barItem.rightBarButtonItem = settingsButton;


    homeBadge = [[UIImageView alloc] initWithFrame:CGRectMake(iPad?70:45, 0, 20, 20)];
    homeBadge.image = [UIImage imageNamed:@"badge"];
    homeBadge.layer.zPosition = 3;
    [bar addSubview:homeBadge];

    lockBadge = [[UIImageView alloc] initWithFrame:CGRectMake(iPad?150:103, 0, 20, 20)];
    lockBadge.image = [UIImage imageNamed:@"badge"];
    lockBadge.layer.zPosition = 3;
    [bar addSubview:lockBadge];

    if ([papers count])
        [self selectedPaper:(LPPaper*)[papers objectAtIndex:0]];
    else
        [self selectedPaper:nil];

    preview = [[LPPreviewView alloc] initWithFrame:[flowView previewFrameForIndex:0]];
    preview.hidden = YES;
    preview.fullScreenFrame = self.view.bounds;
    [self.view addSubview:preview];

    [self armTimer];
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

- (void)configurePaper
{
    if (flowView.flipView) return;
    NSUInteger index = flowView.selectedCoverView.number;
    if ((NSUInteger)index < [papers count])
    {
        LPPaper * paper = (LPPaper*)[papers objectAtIndex:index];
        UIViewController * viewController = paper.preview.prefsViewController;
        if (viewController)
        {
            flippedPaper = paper;
            [paper.preview retain];
            [flowView flipWithView:viewController.view];

            [timer invalidate];
            timer = nil;
            [self timerFired];
            [self disarmTimer];
        }
    }
}

- (void)openFlowFlipViewWillEnd:(AFOpenFlowView*)openFlowView
{
    if (!flippedPaper) return;

    UIViewController * prefsController = flippedPaper.preview.prefsViewController;
    UIViewController * viewController = flippedPaper.preview.viewController;
    if ([prefsController respondsToSelector:@selector(savePreferences)])
        [prefsController performSelector:@selector(savePreferences)];
    if ([viewController respondsToSelector:@selector(reloadPreferences)])
        [viewController performSelector:@selector(reloadPreferences)];

    NSDictionary * ud = [NSDictionary dictionaryWithObject:flippedPaper.bundleID forKey:LCCenterUDPrefsItems];
    [[CPDistributedMessagingCenter centerNamed:LCCenterName] sendMessageName:LCCenterMessagePrefs userInfo:ud];

    preview.paper = flippedPaper;
    UIImage * img = preview.screenShot;
    flippedPaper.image = img;
    [flowView setImage:img forIndex:flippedPaper.index animated:NO];
}

- (void)screen
{
}


- (void)openFlowFlipViewDidEnd:(AFOpenFlowView*)openFlowView
{
    if (!flippedPaper) return;
    [self timerFired];
    [flippedPaper.preview release];
    flippedPaper = nil;
}

- (void)selectedPaper:(LPPaper*)p
{
    if (p)
    {
        barItem.title = p.name;
        homeBadge.hidden = !([homePaper isEqual:p.bundleID]);
        lockBadge.hidden = !([lockPaper isEqual:p.bundleID]);
        barItem.leftBarButtonItems = [NSArray arrayWithObjects:homeButton, lockButton, nil];
        barItem.rightBarButtonItem = p.hasSettings ? settingsButton : nil;
    } else {
        barItem.title = @"Get more wallpapers...";
        homeBadge.hidden = YES;
        lockBadge.hidden = YES;
        barItem.leftBarButtonItems = [NSArray array];
        barItem.rightBarButtonItem = nil;
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
        {
            paper.index = [papers count];
            [papers addObject:paper];
        }
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
    if ((NSUInteger)index < [papers count])
    {
        LPPaper * paper = (LPPaper*)[papers objectAtIndex:index];
        if (!paper.image)
            [self performSelectorInBackground:@selector(loadImageForPaper:) withObject:paper];
        else
            [flowView setImage:paper.image forIndex:index];
    }
    else
        [flowView setImage:moreImage forIndex:index];
}

- (void)loadImageForPaper:(LPPaper*)p
{
    NSAutoreleasePool * pool = [NSAutoreleasePool new];
    UIImage * img = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"/%@/%@/Default.png", LCWallpapersPath, p.bundleID]];
    [self performSelectorOnMainThread:@selector(imageLoadedForPaper:) withObject:[NSArray arrayWithObjects: p, img, nil] waitUntilDone:NO];
    [pool drain];
}

- (void)imageLoadedForPaper:(NSArray*)a
{
    LPPaper * p = (LPPaper*)[a objectAtIndex:0];
    UIImage * img = (UIImage*)[a objectAtIndex:1];
    p.image = img;
    [flowView setImage:img forIndex:p.index];
}

- (void)openFlowViewScrollingDidBegin:(AFOpenFlowView *)openFlowView
{
    [self disarmTimer];

}

- (void)openFlowViewScrollingDidEnd:(AFOpenFlowView *)openFlowView
{
    [self armTimer];
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(NSInteger)index
{
    LPPaper * paper = nil;
    if ((NSUInteger)index < [papers count])
        paper = (LPPaper*)[papers objectAtIndex:index];
    [self selectedPaper:paper];
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView didTap:(NSInteger)index
{
    if (index == flowView.selectedCoverView.number)
    {
        if ((NSUInteger)index < [papers count])
        {
            [self disarmTimer];
            [self timerFired];
            [preview toggleFullScreen];
        } else {
            //TODO
        }
    }
}

- (void)armTimer
{
    if (preview.fullScreen) return;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f 
                                             target:self
                                           selector:@selector(timerFired)
                                           userInfo:nil
                                            repeats:NO];
}

- (void)disarmTimer
{
    [timer invalidate];
    timer = nil;
    LPPaper * paper = preview.paper;
    if (paper)
    {
        UIImage * img = preview.screenShot;
        paper.image = img;
        [flowView setImage:img forIndex:paper.index animated:NO];
    }
    preview.hidden = YES;
}

- (void)timerFired
{
    timer = nil;
    NSUInteger index = flowView.selectedCoverView.number;
    LPPaper * paper = nil;
    if (index < [papers count])
        paper = (LPPaper*)[papers objectAtIndex:index];
    if (paper)
    {
        preview.frame = [flowView previewFrameForIndex:index];
        preview.paper = paper;
        preview.hidden = NO;
    }
}

- (void)dealloc {
    [self disarmTimer];
    [preview release];
    [flowView release];
    [moreImage release];
    [background release];
    [papers release];
    [defaultImage release];
    [label release];
    [barItem release];
    [bar release];
    [homeButton release];
    [lockButton release];
    [settingsButton release];
    [homePaper release];
    [lockPaper release];
    [lockBadge release];
    [homeBadge release];
    [super dealloc];
}
@end
