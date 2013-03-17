

#import "PhysicParticles.h"

@implementation PhysicParticles

@synthesize particleSystem, shape=_shape, body=_body;

- (id) initWithFile:(NSString*)file {
    if (self = [super init]) {
        particleSystem = [[ParticlesManager sharedInstance] getParticle:file]; 
    }
    return self;
}

- (void) setPosition:(CGPoint)position {
    [particleSystem setPosition:position];
    cpBodySetPos(self.body, position);
    [particleSystem setRotation: (float) CC_RADIANS_TO_DEGREES(-self.body->a)];
}

- (void) particleSystemDidExit {
    [[Collector sharedInstance] addParticleSystemToRemove:self];
}

- (void) hasBeenAddedToSpace:(cpSpace *)space managedByLayer:(CCLayer *)layer {
    [layer addChild:self.particleSystem];
    [self performSelector:@selector(particleSystemDidExit) withObject:nil afterDelay:particleSystem.duration];
}

- (void) hasBeenRemovedFromSpace:(cpSpace *)space {
    cpShapeFree(_shape);
    cpBodyFree(_body);
}

@end
