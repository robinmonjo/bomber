//
//  Collector.h
//  Bomber
//
//  Created by Robin Monjo on 9/12/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "NSMutableArray+QueueAddition.h"

@class PhysicParticles;
@class PhysicSprite;

@interface Collector : NSObject


@property (nonatomic, retain) NSMutableArray *spriteToAdd;
@property (nonatomic, retain) NSMutableArray *spriteToRemove;
@property (nonatomic, retain) NSMutableArray *particleSystemToAdd;
@property (nonatomic, retain) NSMutableArray *particleSystemToRemove;

@property (nonatomic, assign) NSInteger pointEarned;

+ (Collector *) sharedInstance;

- (void) addSpriteToRemove:(PhysicSprite *) sprite;
- (void) addSpriteToAdd:(PhysicSprite *) sprite;
- (void) addParticleSystemToAdd:(PhysicParticles *) particle;
- (void) addParticleSystemToRemove:(PhysicParticles *) particle;

- (void) clear;

@end
