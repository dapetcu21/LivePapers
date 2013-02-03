#import "LPScreenView.h"
#import "LPView.h"
#include <dlfcn.h>

@implementation LPScreenView

-(id)initWithMasterView:(LPView*)v
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        master = v;
        [master retain];
    }
    return self;
}

-(void)dealloc
{
    [master release];
    [super dealloc];
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

@end
