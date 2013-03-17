//
//  FragmentGrenadeSprite.m
//  Bomber
//
//  Created by Robin Monjo on 10/3/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "GrenadeSprite.h"
#import "GrenadeFragmentSprite.h"
#import "GameLayer.h"

@implementation GrenadeSprite

@synthesize preparedFragments=_preparedFragments;

#define NB_FRAGS 10

+(GrenadeSprite *) init {
    
    return [GrenadeSprite spriteWithFile:@"grenade.png"];
}

- (id) initWithFile:(NSString *)file {
    
    if(self=[super initWithFile:file]) {
        
        self.body = cpBodyNew(140, INFINITY);
        self.body->velocity_func = &noGravityVelocityFunc;
        
        self.shape = cpCircleShapeNew(self.body, 5, cpvzero);
        
        cpShapeSetElasticity(self.shape, .1f);
        cpShapeSetFriction(self.shape, .3f);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, GRENADE_COLLISION);
        
        self.preparedFragments = [NSMutableArray arrayWithCapacity:NB_FRAGS];
        
        for (NSInteger i = 0; i < NB_FRAGS; ++i) {
            [self.preparedFragments addObject:[GrenadeFragmentSprite init]];
        }
        
        hasFragmented = NO;
        
    }
    return self;
}


- (NSString *) file {
    return @"grenade.png";
}

- (NSString *) label {
    return @"Grenade";
}

- (void) launch {
    cpVect dir = cpvnormalize(cpvsub(self.direction, self.position));
    cpBodyApplyForce(self.body, cpvmult(dir, 100100), cpvzero);
}

- (void) fragment {
    
    if (hasFragmented) return;
    
    hasFragmented = YES;
    
    CGFloat pi = 3.141592f;
    CGFloat step = (2 * pi) / NB_FRAGS;
    CGFloat r = 20.0f;
    
    for (NSInteger i = 0; i < NB_FRAGS; ++i) {
        GrenadeFragmentSprite *fragment = [self.preparedFragments dequeue];
        CGFloat x1 = r * cos(i * step);
        CGFloat y1 = r * sin(i * step);
        fragment.position = self.position;
        fragment.direction = CGPointMake(self.position.x + x1, self.position.y + y1);
        
        [[Collector sharedInstance] addSpriteToAdd:fragment];
    }
    
    [[Collector sharedInstance] addSpriteToRemove:self];
}

@end
