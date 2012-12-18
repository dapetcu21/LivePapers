@interface LPPaper : NSObject {
    NSDictionary * dict;
    NSString * bundleID;
    NSString * name;
    NSString * plugin;
    NSObject * userData;
    BOOL hasSettings;
}

- (id)initWithBundleID:(NSString*)name;

@property(nonatomic, readonly) NSString * bundleID;
@property(nonatomic, readonly) NSString * name;
@property(nonatomic, readonly) NSString * plugin;
@property(nonatomic, readonly) NSObject * userData;
@property(nonatomic, readonly) BOOL hasSettings;

@end
