
#import "Level.h"

@implementation Level

@synthesize bgFile, thumbBgFile, label;


- (id) initWithBgFile:(NSString *)bg{
    if(self = [super init]){
        bgFile = bg;
        thumbBgFile = [NSString stringWithFormat:@"thumb_%@", bg];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)coder {
    //[super encodeWithCoder:coder];
    NSLog(@"encoding level");
    [coder encodeObject:bgFile forKey:@"bgFile"];
    [coder encodeObject:thumbBgFile forKey:@"thumbBgFile"];
    [coder encodeObject:label forKey:@"label"];
}

- (Level*) initWithCoder:(NSCoder *)decoder {
    self = [super init];
    NSLog(@"decoding level");
    bgFile = [decoder decodeObjectForKey:@"bgFile"];
    thumbBgFile = [decoder decodeObjectForKey:@"thumbBgFile"];
    label = [decoder decodeObjectForKey:@"label"];
    NSLog(@"%@, %@, %@", bgFile, thumbBgFile, label);
    return self;
}


@end
