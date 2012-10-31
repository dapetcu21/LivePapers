@interface LPPlugin : NSObject
{
    NSString * name;
    void * lib;
    UIViewController * (*fcn)(NSObject*);
}

@property(nonatomic, readonly) NSString * name;

-(id)initWithName:(NSString*)name;
-(UIViewController*)newViewController:(NSObject*)ud;

@end
