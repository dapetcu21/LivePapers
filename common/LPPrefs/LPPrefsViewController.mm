#import "LPPrefsViewController.h"
#import "LPPref.h"

@interface LPPrefsScrollView : UIScrollView
@end
@implementation LPPrefsScrollView
-(void)layoutSubviews
{
    CGRect frame = self.frame;
    UIView * v = [self viewWithTag:1];
    CGRect f = v.frame;
    f.size.width = frame.size.width;
    v.frame = f;
    self.contentSize = f.size;
}
@end

@implementation LPPrefsViewController
@synthesize rootViewController;
@synthesize animateTransitions;

-(id)init
{
    if ((self = [super init]))
    {
        prefs = [[NSMutableArray alloc] init];
        animateTransitions = YES;
    }
    return self;
}

-(void)dealloc
{
    [prefs release];
    [super dealloc];
}

-(NSArray*)allPrefs
{
    return (NSArray*)prefs;
}

#ifndef LP_STRINGIFY
#define LP_STRINGIFY2(x) #x
#define LP_STRINGIFY(x) LP_STRINGIFY2(x)
#endif

-(void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:frame];
    self.view = bgView;
    bgView.autoresizesSubviews = YES;
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor blackColor];

    CGRect b = bgView.bounds;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        UINavigationBar * bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, b.size.width, 44)];
        UINavigationItem * barItem = [[UINavigationItem alloc] init];
        [bar pushNavigationItem:barItem animated:NO];
        bar.barStyle = UIBarStyleBlack;
        UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self.rootViewController
                                                 action:@selector(dismissPreferencesView)];
        barItem.rightBarButtonItem = button;
        #ifdef PH_APP_TARGET
        barItem.title = @ LP_STRINGIFY(PH_APP_TARGET);
        #endif
        [button release];
        [bgView addSubview: bar];
        [barItem release];
        [bar release];

        b.size.height -= 44;
        b.origin.y += 44;
    }

    
    UIScrollView * scroll = [[LPPrefsScrollView alloc] initWithFrame:b];
    scroll.clipsToBounds = YES;
    scroll.tag = 12;
    scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [bgView addSubview:scroll];
    [bgView release];

    UIView * contentsView = [[UIView alloc] initWithFrame:b];
    contentsView.tag = 1;
    contentsView.autoresizesSubviews = YES;
    [scroll addSubview:contentsView];

    float currentHeight = 0.0f;
    for (LPPref * p in prefs)
    {
        UIView * v = p.view;
        CGRect r = v.frame;
        r.size.width = b.size.width;
        r.origin.y = currentHeight;
        currentHeight += r.size.height;
        v.frame = r;

        [contentsView addSubview:v];
    }

    CGRect r = CGRectMake(0, 0, b.size.width, currentHeight + 30.0);
    contentsView.frame = r;
    scroll.contentSize = r.size;
    [scroll release];
    [contentsView release];
}

-(LPPref*)prefWithTag:(int)tag
{
    for (LPPref * p in prefs)
        if (p.tag == tag)
            return p;
    return nil;
}

-(void)addPref:(LPPref*)pref
{
    [prefs addObject:pref];
    pref.controller = self;
}

-(void)prefDidChange:(LPPref*)pref
{
}


-(void)_prefToggledHidden:(LPPref*)pref
{
    void (^block)(void) = ^(){
        float offset = 0.0f;
        for (LPPref * p in prefs)
        {
            if (p == pref)
            {
                offset = ( pref.hidden ? -1 : 1 ) * pref.view.frame.size.height;
                pref.view.alpha = pref.hidden ? 0.0 : 1.0;
            } else
                if (offset)
                {
                    CGRect r = p.view.frame;
                    r.origin.y += offset;
                    p.view.frame = r;
                }
        }
        UIScrollView * scroll = (UIScrollView*)[self.view viewWithTag:12];
        UIView * contentsView = [scroll viewWithTag:1];

        CGRect f = contentsView.frame;
        f.size.height += offset;
        contentsView.frame = f;

        CGSize sz = scroll.contentSize;
        sz.height += offset;
        scroll.contentSize = sz;
    };
    if (animateTransitions)
        [UIView animateWithDuration:0.5f animations:block];
    else
        block();
}

@end
