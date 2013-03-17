//
//  FireBallSprite.m
//  Bomber
//
//  Created by Robin Monjo on 9/20/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "FireBallSprite.h"

@implementation FireBallSprite

+(FireBallSprite *) init {
    
    return [FireBallSprite spriteWithFile:@"fire_ball.png"];
}

- (id) initWithFile:(NSString *)file {
    
    if(self=[super initWithFile:file]) {
        
        self.body = cpBodyNew(90, INFINITY);
        self.body->velocity_func = &noGravityVelocityFunc;
        
        self.shape = cpCircleShapeNew(self.body, 5, cpvzero);
                
        cpShapeSetElasticity(self.shape, .1f);
        cpShapeSetFriction(self.shape, .3f);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, FIRE_BALL_COLLISION);
        
        _willBeRemoved = NO;
    }
    return self;
}


- (NSString *) file {
    return @"kamea.png";
}

- (NSString *) label {
    return @"Fire Ball";
}

- (void) launch {
    cpVect dir = cpvnormalize(cpvsub(self.direction, self.position));
    cpBodyApplyForce(self.body, cpvmult(dir, 100100), cpvzero);
}

- (void) hasCollide {
    
    if (_willBeRemoved) {
        return;
    }
    
    _willBeRemoved = YES;
    
    CCParticleSystemQuad *particles = [[ParticlesManager sharedInstance] getParticle:@"FireBallParticle.plist"];
    
    particles.position = self.position;
    particles.scale = 0.5;
    
    [self.parent addChild:particles z:100];
    [[Collector sharedInstance] addSpriteToRemove:self];
}


@end
