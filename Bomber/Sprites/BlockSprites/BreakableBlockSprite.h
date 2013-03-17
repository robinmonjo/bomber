
#import "BlockSprite.h"
#import "BlockZone.h"

#import "NSMutableArray+QueueAddition.h"

@interface BreakableBlockSprite : BlockSprite {
@private
    BlockZone *zone1;
    BlockZone *zone2;
    BlockZone *zone3;
    
    cpFloat resistance;
    
    NSString *particleFile;
    
    NSMutableArray *_preparedFrags;
}

@property (nonatomic, retain) BlockZone *zone1;
@property (nonatomic, retain) BlockZone *zone2;
@property (nonatomic, retain) BlockZone *zone3;
@property (nonatomic, retain) NSMutableArray *preparedFrags;

-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
                                    mass:(cpFloat)mass resistance:(cpFloat) res particleFile:(NSString*)file;

- (void) atomizeBlock;

- (void) prepareFragments;

@end
