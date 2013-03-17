#import "BlockSprite.h"
#import "BreakableBlockSprite.h"

@interface BlockSpriteFactory : NSObject

+ (BlockSprite*) createMediumMassSolidBlockWithRect:(CGRect) rect;
+ (BlockSprite*) createHighMassSolidBlockWithRect:(CGRect) rect;

+ (BreakableBlockSprite*) createHighMassBreakableBlockWithRect:(CGRect) rect;
+ (BreakableBlockSprite*) createMediumMassBreakableBlockWithRect:(CGRect) rect;
+ (BreakableBlockSprite*) createLowMassBreakableBlockWithRect:(CGRect) rect;


@end
