
#import "PhysicSprite.h"
#import "WeaponSpriteProtocol.h"

@interface BombSprite : PhysicSprite <WeaponSpriteProtocol> 

+ (BombSprite*) init;

-(void) startCountDown;

@end
