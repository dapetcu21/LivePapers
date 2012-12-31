#import "LPDefaultViewController.h"
#include <dlfcn.h>

@implementation LPDefaultViewController

UIImage* (*LPGetGradient)(int) = NULL;

-(void)loadView
{
    CGRect f = [UIScreen mainScreen].bounds;
    UIView * v = [[UIView alloc] initWithFrame:f];
    [imageView release];
    [gradient release];
    imageView = [[UIImageView alloc] initWithFrame:f];
    gradient = [[UIImageView alloc] initWithFrame:f];
    [v addSubview:imageView];
    [v addSubview:gradient];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gradient.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = v;
    [v release];
}

-(void)dealloc
{
    [imageView release];
    [gradient release];
    [super dealloc];
}

-(void)setWallpaperImage:(UIImage*)img
{
    if (!LPGetGradient)
    {
        void * h = dlopen(NULL, RTLD_LAZY | RTLD_LOCAL);
        LPGetGradient = dlsym(h, "SBWallpaperGradientImageForInterfaceOrientation");
    }
    gradient.image = LPGetGradient([[UIApplication sharedApplication] statusBarOrientation]);
    imageView.image = img;
}

-(void)setWallpaperRect:(CGRect)r
{
    CGRect f = self.view.bounds;
    r.origin.x = -(r.origin.x / r.size.width) * (f.size.width / r.size.width);
    r.origin.y = -(r.origin.y / r.size.height) * (f.size.height / r.size.height);
    r.size.width = f.size.width / r.size.width;
    r.size.height = f.size.height / r.size.height;
    gradient.frame = f;
    imageView.frame = f;
    imageView.bounds = r;
}

@end
