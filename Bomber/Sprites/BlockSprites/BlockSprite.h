
#import "PhysicSprite.h"


@interface BlockSprite : PhysicSprite

- (id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect mass:(cpFloat) mass;

- (void) impactAtPoint:(CGPoint) p withDamage:(float) damage;
- (BOOL) canBeDivided;

- (void) makeBlockPerformAction:(CCAction *)action;

@end
