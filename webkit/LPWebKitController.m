#import "LPWebKitController.h"

@implementation LPWebKitController 

-(void)loadView
{
    CGRect f = [UIScreen mainScreen].bounds;
    UIView * v = [[UIView alloc] initWithFrame:f];
    v.autoresizesSubviews = YES;

    webView = [[UIWebBrowserView alloc] initWithFrame:f];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [v addSubview:webView];

    self.view = v;
    [v release];

    [self reloadPreferences];
}

-(void)dealloc
{
    [webView release];
    [url release];
    [super dealloc];
}

-(void)reloadPreferences
{
    if (!webView) return;
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)setUrl:(NSURL*)u
{
    if (u != url)
    {
        [u retain];
        [url release];
        url = u;
        [self reloadPreferences];
    }
}

-(NSURL*)url
{
    return url;
}

@end
