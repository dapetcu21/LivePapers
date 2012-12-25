@class LPPreview;

@interface LPPaper : NSObject {
    NSDictionary * dict;
    NSString * bundleID;
    NSString * name;
    NSString * plugin;
    NSObject * userData;
    NSInteger index;
    BOOL hasSettings;
    UIImage * image;
    LPPreview * preview;
}

- (id)initWithBundleID:(NSString*)name;

@property(nonatomic, readonly) NSString * bundleID;
@property(nonatomic, readonly) NSString * name;
@property(nonatomic, readonly) NSString * plugin;
@property(nonatomic, readonly) NSObject * userData;
@property(nonatomic, readonly) BOOL hasSettings;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, retain) UIImage * image;
@property(nonatomic, readonly) LPPreview * preview;

@end
