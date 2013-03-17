#import "chipmunk.h"
#import "ParticlesManager.h"
#import "PhysicSprite.h"

@interface PhysicParticles : NSObject <SpaceInsertionSuppression> {
@protected
    CCParticleSystemQuad *particleSystem;
    cpShape *_shape;
    cpBody *_body;
}

@property (nonatomic, retain) CCParticleSystemQuad *particleSystem;
@property (nonatomic, assign) cpShape *shape;
@property (nonatomic, assign) cpBody *body;

- (id) initWithFile:(NSString*)file;

- (void) setPosition:(CGPoint) position;


@end
