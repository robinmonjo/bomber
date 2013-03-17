
#import "PhysicSprite.h"

@class FireParticles;
@class ExplosionParticles;

@interface DrumSprite : PhysicSprite {
@private
    BOOL hasExplode;
    
    FireParticles *_fireParticles;
    ExplosionParticles *_explosionParticles;
}

@property (nonatomic, retain) FireParticles *fireParticles;
@property (nonatomic, retain) ExplosionParticles *explosionParticles;

@property (nonatomic, assign) cpShape *explodeShape;

+(DrumSprite*) init;

- (void) explode;

@end
