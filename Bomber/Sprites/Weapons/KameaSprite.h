

#import "LaunchableWeaponSprite.h"

@interface KameaSprite : LaunchableWeaponSprite {
@private
    CGFloat resistance;
    CCMotionStreak *streak;
}

+(KameaSprite*) init;

- (void) lowerResistanceBy:(float) damage;


@end
