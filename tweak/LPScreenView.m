#import "LPScreenView.h"
#import "LPView.h"
#import "LPController.h"
#include <dlfcn.h>

@implementation LPScreenView

-(id)initWithMasterView:(LPView*)v
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        master = v;
        retainsMaster = [LPController sharedInstance].initializingFolders;
        [master retain];
    }
    return self;
}

-(void)dealloc
{
    if (retainedMaster)
        [master removeScreenView];
    [master release];
    [super dealloc];
}

- (void)willMoveToWindow:(UIWindow *)window
{
    if (!retainsMaster) return;
    BOOL b = window != 0;
    if (b == retainedMaster) return;
    retainedMaster = b;
    if (b)
        [master addScreenView];
    else
        [master removeScreenView];
}


-(void)drawRect:(CGRect)rect
{
    [[master image] drawInRect:self.bounds];
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
        [UIView beginAnimations:@"rotateDummyWallpaper" context:nil];
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
    [self setNeedsDisplay];
}

-(int)orientation
{
    return orient;
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

-(UIImage*)image
{
    return nil;
}

-(void)setImage:(UIImage*)img
{
}

-(void)resetCurrentImageToWallpaper
{
}

-(void)replaceWallpaperWithImage:(UIImage*)image
{
}

@end
