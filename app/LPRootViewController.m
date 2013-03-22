#import "LPRootViewController.h"
#import "LPPaper.h"
#import "LPPreview.h"
#import "AFOpenFlowView.h"
#import "LPCommon.h"
#import "LPPreviewView.h"
#import <AppSupport/CPDistributedMessagingCenter.h>
#import "LPColorWheel.h"

__attribute__((visibility("default")))
float LPGetIdleTimeout()
{
    return 10000000;
}

@implementation LPRootViewController
- (void)loadView {
    [self loadPapers];

    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);

    defaultImage = [[UIImage imageNamed:@"placeholder"] retain];
    moreImage = [[UIImage imageNamed:@"more"] retain];

    CGRect r = [[UIScreen mainScreen] applicationFrame];
    UIImageView * view = [[[UIImageView alloc] initWithFrame:r] autorelease];
    view.userInteractionEnabled = YES;
    view.image = [UIImage imageNamed:@"background"];
    self.view = view;

    CGFloat scale = r.size.width / 768.0f;
    flowView = [[AFOpenFlowView alloc] initWithFrame:view.bounds];
    CGFloat s = r.size.width * (1024.0/768.0) * 0.7;
//    flowView.sideCoverAngle = 0.5;
    flowView.coverImageSize = s;
    flowView.sideCoverZPosition = -140 * scale;
    flowView.sideOffset = 80 * scale;
    flowView.coverSpacing = 40 * scale;
    flowView.centerCoverOffset = 60 * scale;
    flowView.dragDivisor = 3;
    flowView.coverHeightOffset = 0;
    flowView.dataSource = self;
    flowView.viewDelegate = self;
    [self.view addSubview:flowView];

    bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(view.bounds.origin.x, view.bounds.origin.y, r.size.width, 44)];
    [flowView addSubview:bar];
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
    {
        LPPaper * pp = (LPPaper*)[papers objectAtIndex:0];
        for (LPPaper * paper in papers)
            if ([paper.bundleID isEqual:homePaper])
            {
                pp = paper;
                [flowView setSelectedCover:pp.index];
                break;
            }
        [self selectedPaper:pp];
    }
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

- (void)dismissPreferencesView
{
    [flowView dismissFlipView];
}

- (void)configurePaper
{
    if (flowView.flipView)
    {
        [self dismissPreferencesView];
        return;
    }
    NSUInteger index = flowView.selectedCoverView.number;
    if ((NSUInteger)index < [papers count])
    {
        LPPaper * paper = (LPPaper*)[papers objectAtIndex:index];
        UIViewController * viewController = paper.preview.prefsViewController;
        if (viewController)
        {
            if ([viewController respondsToSelector:@selector(setRootViewController:)])
                [viewController performSelector:@selector(setRootViewController:) withObject:self];
            flippedPaper = paper;
            [paper.preview retain];
            UIView * view = viewController.view;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                view.frame = [flowView previewFrameForIndex:index];
            else
                view.frame = flowView.bounds;
            [flowView flipWithView:view];

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
    [[NSFileManager defaultManager] createDirectoryAtPath:LCIconCachePath withIntermediateDirectories:YES attributes:nil error:NULL];

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

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * p = (NSString*)[defaults stringForKey:LCPrefsHomeKey];
    if (![p isKindOfClass:[NSString class]])
        p = LCDefaultPaper;
    homePaper = [p retain];
    p = (NSString*)[defaults stringForKey:LCPrefsLockKey];
    if (![p isKindOfClass:[NSString class]])
        p = LCDefaultPaper;
    lockPaper = [p retain];
}

-(void)saveSettings:(NSString*)s
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:homePaper forKey:LCPrefsHomeKey];
    [defaults setObject:lockPaper forKey:LCPrefsLockKey];
    [defaults synchronize];
    
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
    UIImage * img = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/%@.png", LCIconCachePath, p.bundleID]];
    if (!img)
        img = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/%@/Default.png", LCWallpapersPath, p.bundleID]];
    if (!img)
        img = defaultImage;
    //NSLog(@"here goes an image: %@ %@", p, img);
    [self performSelectorOnMainThread:@selector(imageLoadedForPaper:) withObject:[[NSArray arrayWithObjects: p, img, nil] retain] waitUntilDone:YES];
    [pool drain];
}

- (void)imageLoadedForPaper:(NSArray*)a
{
    LPPaper * p = (LPPaper*)[a objectAtIndex:0];
    UIImage * img = (UIImage*)[a objectAtIndex:1];
    //NSLog(@"Here went an image: %@ %@", p, img);
    p.image = img;
    [flowView setImage:img forIndex:p.index];
    [a release];
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
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: LCCydiaURL]];
        }
    }
}

- (void)armTimer
{
    if (preview.fullScreen) return;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.3f 
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


- (LPColorWheel*)newColorWheel
{
    return [[LPColorWheel alloc] initWithRootViewController:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    else
        return UIInterfaceOrientationMaskPortrait;
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
