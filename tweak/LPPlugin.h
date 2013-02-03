@interface LPPlugin : NSObject
{
    NSString * name;
    void * lib;
    UIViewController * (*fcn)(NSDictionary*);
}

@property(nonatomic, readonly) NSString * name;

-(id)initWithName:(NSString*)name;
-(UIViewController*)newViewController:(NSDictionary*)info;

@end
