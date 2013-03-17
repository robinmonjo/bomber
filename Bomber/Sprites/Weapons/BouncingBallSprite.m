//
//  BouncingBallSprite.m
//  Bomber
//
//  Created by Robin Monjo on 9/22/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "BouncingBallSprite.h"
#import "ExplosionParticles.h"

#define MAX_NB_BOUNCES 3

@implementation BouncingBallSprite

+(BouncingBallSprite *) init {
    return [BouncingBallSprite spriteWithFile:@"fire_ball.png"];
}

-(id) initWithFile:(NSString *)file {
    
    if(self=[super initWithFile:file]) {
        
        cpFloat moment = cpMomentForCircle(30, 0, 7, cpvzero);
        
        self.body = cpBodyNew(30, moment);
        self.body->velocity_func = &noGravityVelocityFunc;
        
        self.shape = cpCircleShapeNew(self.body, 7, cpvzero);
        cpShapeSetElasticity(self.shape, 1.0f);
        cpShapeSetFriction(self.shape, .0f);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, BOUNCING_BALL_COLLISION);
        
        _nbBounces = 0;
    }
    return self;
}

- (NSString *) file {
    return @"fire_ball.png";
}

- (NSString *) label {
    return @"Bouncing Ball";
}

- (void) launch {
    cpVect dir = cpvnormalize(cpvsub(self.direction, self.position));
    cpBodyApplyImpulse(self.body, cpvmult(dir, 10700), cpvzero);
}

- (void) hasBounced {
    
    ExplosionParticles *explosion = [ExplosionParticles initWithRadius:20];
    [explosion setPosition:self.position];
    [[Collector sharedInstance] addParticleSystemToAdd:explosion];
    
    ++_nbBounces;
    if (_nbBounces == MAX_NB_BOUNCES) {
        [[Collector sharedInstance] addSpriteToRemove:self];
    }
}

@end
