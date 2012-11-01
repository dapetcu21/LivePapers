#import "LPDefaultViewController.h"

@implementation LPDefaultViewController

-(void)loadView
{
    UIImageView * v = [[UIImageView alloc] init];
    self.view = v;
    [v release];
}

-(void)setWallpaperImage:(UIImage*)img
{
    ((UIImageView*)self.view).image = img;
}

-(void)setWallpaperRect:(CGRect)r
{
    CGRect f = self.view.frame;
    r.origin.x = -(r.origin.x / r.size.width) * (f.size.width / r.size.width);
    r.origin.y = -(r.origin.y / r.size.height) * (f.size.height / r.size.height);
    r.size.width = f.size.width / r.size.width;
    r.size.height = f.size.height / r.size.height;
    self.view.bounds = r;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"LivePapers: ---------- viewWillAppear %d", animated);
//    NSLog(@"%@", [NSThread callStackSymbols]);
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"LivePapers: ---------- viewDidAppear %d", animated);
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"LivePapers: ---------- viewDidDisappear %d", animated);
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"LivePapers: ---------- viewWillDisappear %d", animated);
}

@end
