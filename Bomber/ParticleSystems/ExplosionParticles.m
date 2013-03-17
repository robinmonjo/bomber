//
//  ExplosionParticles.m
//  Bomber
//
//  Created by Robin Monjo on 9/12/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "ExplosionParticles.h"

@implementation ExplosionParticles

+ (ExplosionParticles *) initWithRadius:(CGFloat) radius {
    return [[ExplosionParticles alloc] initWithRadius:radius];
}

- (id) initWithRadius:(CGFloat) radius {
    if (self = [super initWithFile:@"ExplosionParticle.plist"]) {
        
        particleSystem.scale = radius/100;
        particleSystem.autoRemoveOnFinish = YES;
        
        self.body = cpBodyNewStatic();
        cpBodySetVel(self.body, cpv(20, 20));
        
        self.shape = cpCircleShapeNew(self.body, radius, cpvzero);
        cpShapeSetFriction(self.shape, 1.0f);
        cpShapeSetElasticity(self.shape, 1.0f);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, EXPLOSION_COLLISION);
    }
    return self;
}

- (void) removePhysicFromSpace {
    [[Collector sharedInstance] addParticleSystemToRemove:self];
}

- (void) hasBeenAddedToSpace:(cpSpace *)space managedByLayer:(CCLayer *)layer {
    [layer addChild:self.particleSystem];
    [self performSelector:@selector(removePhysicFromSpace) withObject:nil afterDelay:.2f];
}

- (void) hasBeenRemovedFromSpace:(cpSpace *)space {
    cpShapeFree(_shape);
    cpBodyFree(_body);
}

@end
