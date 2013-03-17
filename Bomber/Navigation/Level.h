
@interface Level : NSObject <NSCoding> {
@protected
    NSString *bgFile;
    NSString *thumbBgFile;
    NSString *label;
}


@property (nonatomic, retain) NSString *bgFile;
@property (nonatomic, retain) NSString *thumbBgFile;
@property (nonatomic, retain) NSString *label;

- (id) initWithBgFile:(NSString*)bg;

- (CCScene *) scene; 

- (BOOL) isAccessible;

@end
