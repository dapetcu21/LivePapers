#import "LPColorWheel.h"
#import "ColorPicker/InfColorPickerController.h"

@implementation LPColorWheel
@synthesize delegate;
@synthesize rootViewController = _rootViewController;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        CALayer * layer = self.layer;
        layer.cornerRadius = 5.0;
        layer.borderWidth = 2.0;
        layer.borderColor = [UIColor whiteColor].CGColor;
        layer.shadowOpacity = 0.5;
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController*)vc
{
    if ((self = [super init]))
    {
        _rootViewController = vc;
        CALayer * layer = self.layer;
        layer.cornerRadius = 5.0;
        layer.borderWidth = 2.0;
        layer.borderColor = [UIColor whiteColor].CGColor;
        layer.shadowOpacity = 0.5;
    }
    return self;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [popoverController release];
}

- (void) colorPickerControllerDidChangeColor: (InfColorPickerController*) controller
{
    self.backgroundColor = controller.resultColor;
    [self.delegate colorWheel:self changedColor:controller.resultColor];
}

- (void) colorPickerControllerDidFinish:(InfColorPickerController*) controller
{
    if (_rootViewController)
        [_rootViewController dismissModalViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    InfColorPickerController * vc = [InfColorPickerController colorPickerViewController]; 
    vc.delegate = (id<InfColorPickerControllerDelegate>)self;
    vc.sourceColor = self.backgroundColor;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIPopoverController * pov = [[UIPopoverController alloc] initWithContentViewController:vc];
        [pov presentPopoverFromRect:self.bounds inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [pov setPopoverContentSize:[InfColorPickerController idealSizeForViewInPopover]];
    } else {
        if (_rootViewController)
            [vc presentModallyOverViewController:_rootViewController];
    }
}

@end
