//
//  Collector.m
//  Bomber
//
//  Created by Robin Monjo on 9/12/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "Collector.h"
#import "PhysicSprite.h"

@implementation Collector

@synthesize spriteToAdd, spriteToRemove, particleSystemToAdd, particleSystemToRemove, pointEarned;

static Collector *instance;

+ (Collector *) sharedInstance {
    @synchronized(self) {
        
        if (instance == NULL)
            instance = [[self alloc] init];
    }
    
    return(instance);
}

- (id) init {
    if (self = [super init]) {
        self.spriteToAdd = [NSMutableArray array];
        self.spriteToRemove = [NSMutableArray array];
        self.particleSystemToAdd = [NSMutableArray array];
        self.particleSystemToRemove = [NSMutableArray array];
        
        self.pointEarned = 0;
    }
    return self;
}

- (void) addSpriteToRemove:(PhysicSprite *) sprite {
    if (![self.spriteToRemove containsObject:sprite]) {
        self.pointEarned += sprite.pointEarnedWhenDestroyed;
        [self.spriteToRemove enqueue:sprite];
    }
}

- (void) addSpriteToAdd:(PhysicSprite *) sprite {
    if (![self.spriteToAdd containsObject:sprite]) {
        [self.spriteToAdd enqueue:sprite];
    }
}

- (void) addParticleSystemToAdd:(PhysicParticles *) particle {
    if (![self.particleSystemToAdd containsObject:particle]) {
        [self.particleSystemToAdd enqueue:particle];
    }
}

- (void) addParticleSystemToRemove:(PhysicParticles *) particle {
    if (![self.particleSystemToRemove containsObject:particle]) {
        [self.particleSystemToRemove enqueue:particle];
    }
}



- (void) clear {
    [self.spriteToAdd removeAllObjects];
    [self.spriteToRemove removeAllObjects];
    [self.particleSystemToAdd removeAllObjects];
    [self.particleSystemToRemove removeAllObjects];
}

@end
