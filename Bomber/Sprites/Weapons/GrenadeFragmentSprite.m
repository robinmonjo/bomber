//
//  GrenadeFragmentSprite.m
//  Bomber
//
//  Created by Robin Monjo on 10/3/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "GrenadeFragmentSprite.h"
#import "ExplosionParticles.h"

@implementation GrenadeFragmentSprite

+(GrenadeFragmentSprite *) init {
    
    return [GrenadeFragmentSprite spriteWithFile:@"fragment_grenade.png"];
}

- (id) initWithFile:(NSString *)file {
    
    if(self=[super initWithFile:file]) {
        
        self.body = cpBodyNew(100, INFINITY);
        self.body->velocity_func = &noGravityVelocityFunc;
        
        self.shape = cpCircleShapeNew(self.body, 2, cpvzero);
        
        cpShapeSetElasticity(self.shape, 1.0f);
        cpShapeSetFriction(self.shape, .3f);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, GRENADE_FRAGMENT_COLLISION);
        
    }
    return self;
}


#warning not needed
- (NSString *) file {
    return nil;
}

- (NSString *) label {
    return nil;
}

- (void) launch {
    cpVect dir = cpvnormalize(cpvsub(self.direction, self.position));
    cpBodyApplyImpulse(self.body, cpvmult(dir, 19000), cpvzero);
}

- (void) hasCollid {
    [[Collector sharedInstance] addSpriteToRemove:self];

    ExplosionParticles *explosion = [ExplosionParticles initWithRadius:20];
    [explosion setPosition:self.position];
    [[Collector sharedInstance] addParticleSystemToAdd:explosion];
}

@end
