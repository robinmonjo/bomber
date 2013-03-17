
#import "PhysicSprite.h"
#import "WeaponSpriteProtocol.h"

@interface AnvilSprite : PhysicSprite <WeaponSpriteProtocol>

+(AnvilSprite*) init;

@end
