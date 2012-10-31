#import "LPScreenView.h"
#include <dlfcn.h>

@implementation LPScreenView

-(id)initWithMasterView:(UIView*)v
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        master = v;
        [master retain];
        [self setImage:nil];
    }
    return self;
}

-(void)dealloc
{
    [master release];
    [super dealloc];
}

//-- SBWallpaperView interface

-(void)setOrientation:(int)o
{
    [self setOrientation:o duration:0];
}

-(void)setOrientation:(int)o duration:(float)dur
{
    if (dur)
    {
        [UIView beginAnimations:@"rotateWallpaper" context:nil];
        [UIView setAnimationDuration: dur];
    }
    CGRect f = [[UIScreen mainScreen] bounds];
    if (o>2)
    {
        CGFloat a = f.size.width;
        f.size.width = f.size.height;
        f.size.height = a;
    }
    self.frame = f;
    if (dur)
        [UIView commitAnimations];
    orient = o;
}


-(int)orientation
{
    return orient;
}

-(void)didMoveToWindow
{
    CGRect rect = [master bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [master.layer renderInContext:context];   
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [super setImage:capturedImage];
}

-(CGRect)wallpaperContentsRect
{
    return CGRectMake(0, 0, 1, 1);
}

-(UIImage*)gradientImageForInterfaceOrientation:(int)orient
{
    return [[[UIImage alloc] init] autorelease];
}

-(void)setFlushWallpaperAutomatically:(BOOL)n
{
}

-(void)setPostsNotifications:(BOOL)n
{
}

@end
