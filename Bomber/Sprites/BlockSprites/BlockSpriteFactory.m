

#import "BlockSpriteFactory.h"

@implementation BlockSpriteFactory

#define HIGH_MASS(rect)         ((rect.size.width*rect.size.height)/2.5)
#define MEDIUM_MASS(rect)       ((rect.size.width*rect.size.height)/5)
#define LOW_MASS(rect)          ((rect.size.width*rect.size.height)/10)

#define HIGH_RESISTANCE(rect)   ((HIGH_MASS(rect))/3)
#define MEDIUM_RESISTANCE(rect) ((MEDIUM_MASS(rect))/6)
#define LOW_RESISTANCE(rect)    ((LOW_MASS(rect))/9)

#define IS_HORIZONTAL(rect)     (rect.size.height > rect.size.width)


+ (BlockSprite*) createMediumMassSolidBlockWithRect:(CGRect) rect {
    NSString *file = [NSString stringWithFormat:@"%@_medium_mass_solid_block.png",
                      IS_HORIZONTAL(rect) ? @"vert" : @"horiz"];
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:file];
    return [[BlockSprite alloc] initWithTexture:texture rect:rect mass:MEDIUM_MASS(rect)];
}

+ (BlockSprite*) createHighMassSolidBlockWithRect:(CGRect) rect {
    NSString *file = [NSString stringWithFormat:@"%@_high_mass_solid_block.png",
                      IS_HORIZONTAL(rect) ? @"vert" : @"horiz"];
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:file];
    return [[BlockSprite alloc] initWithTexture:texture rect:rect mass:HIGH_MASS(rect)];
}

+ (BreakableBlockSprite*) createHighMassBreakableBlockWithRect:(CGRect) rect {
    NSString *file = [NSString stringWithFormat:@"%@_high_mass_breakable_block.png",
                      IS_HORIZONTAL(rect) ? @"vert" : @"horiz"];
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:file];
    BreakableBlockSprite *block = [[BreakableBlockSprite alloc] initWithTexture:texture rect:rect
                                                    mass:HIGH_MASS(rect) resistance:HIGH_RESISTANCE(rect)
                                            particleFile:@"high_mass_breakable_block_particle.plist"];
    block.pointEarnedWhenDestroyed = (NSInteger) (rect.size.width * rect.size.height) / 10;
    [block prepareFragments];
    return block;
}

+ (BreakableBlockSprite*) createMediumMassBreakableBlockWithRect:(CGRect) rect {
    NSString *file = [NSString stringWithFormat:@"%@_medium_mass_breakable_block.png",
                      IS_HORIZONTAL(rect) ? @"vert" : @"horiz"];
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:file];
    BreakableBlockSprite *block = [[BreakableBlockSprite alloc] initWithTexture:texture rect:rect
                                                    mass:MEDIUM_MASS(rect) resistance:MEDIUM_RESISTANCE(rect)
                                            particleFile:@"medium_mass_breakable_block_particle.plist"];
    block.pointEarnedWhenDestroyed = (NSInteger) (rect.size.width * rect.size.height) / 30;
    [block prepareFragments];
    return block;
}

+ (BreakableBlockSprite*) createLowMassBreakableBlockWithRect:(CGRect) rect {
    NSString *file = [NSString stringWithFormat:@"%@_low_mass_breakable_block.png",
                      IS_HORIZONTAL(rect) ? @"vert" : @"horiz"];
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:file];
    BreakableBlockSprite *block = [[BreakableBlockSprite alloc] initWithTexture:texture rect:rect
                                                    mass:LOW_MASS(rect) resistance:LOW_RESISTANCE(rect)
                                            particleFile:@"low_mass_breakable_block_particle.plist"];
    block.pointEarnedWhenDestroyed = (NSInteger) (rect.size.width * rect.size.height) / 50;
    [block prepareFragments];
    return block;
}

@end
