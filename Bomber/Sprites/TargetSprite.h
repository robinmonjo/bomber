
#import "PhysicSprite.h"

@interface TargetSprite : PhysicSprite {
@private
    CGFloat resistance;
}

+ (TargetSprite*) init;

-(void) moquePlayer;
-(void) addDamage:(float) damage;

@end
