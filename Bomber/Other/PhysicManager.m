//
//  PhysicManager.m
//  Bomber
//
//  Created by Robin Monjo on 9/12/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "PhysicManager.h"
#import "PhysicParticles.h"
#import "PhysicSprite.h"

#import "CollisionBegins.m"
#import "CollisionPresolve.m"
#import "CollisionPostsolve.m"
#import "CollisionSeparates.m"

@implementation PhysicManager

@synthesize space=_space;

- (id) init {
    if (self = [super init]) {
        collector = [Collector sharedInstance];
    }
    return self;
}

- (void) initSpace {
    self.space = cpSpaceNew();
    cpSpaceSetGravity(self.space, cpv(0, -100));
    
    [self setUpWalls];
    [self setUpCollisionsHandlers];
}

#define WALL_OFSET 100.0f //to avoid body passing through a wall after a huge collision

- (void) setUpWalls {
    CGSize screen = [[CCDirector sharedDirector] winSize];
	
	// bottom
	_walls[0] = cpSegmentShapeNew(_space->staticBody, cpv(0, -WALL_OFSET), cpv(screen.width, -WALL_OFSET), WALL_OFSET);
	
	// top
	_walls[1] = cpSegmentShapeNew(_space->staticBody, cpv(0, screen.height+WALL_OFSET), cpv(screen.width, screen.height+WALL_OFSET), WALL_OFSET);
	
	// left
	_walls[2] = cpSegmentShapeNew( _space->staticBody, cpv(-WALL_OFSET, 0), cpv(-WALL_OFSET, screen.height), WALL_OFSET);
	
	// right
	_walls[3] = cpSegmentShapeNew( _space->staticBody, cpv(screen.width+WALL_OFSET, 0), cpv(screen.width+WALL_OFSET, screen.height), WALL_OFSET);
	
	for(int i = 0; i < 4; ++i) {
		cpShapeSetElasticity(_walls[i], .5f);
		cpShapeSetFriction(_walls[i], 1.0f);
		cpSpaceAddStaticShape(_space, _walls[i]);
	}
}

- (void) addPhysicSprite:(PhysicSprite *) sprite {
    cpSpaceAddShape(self.space, sprite.shape);
    if (!cpBodyIsStatic(sprite.body)) {
        cpSpaceAddBody(self.space, sprite.body);
    }
}


- (void) takeStep:(CGFloat)dt inLayer:(CCLayer *) layer {
    cpSpaceStep(self.space, dt);
    [self runCollector:layer];
}

#define NB_MAX_ELEMENTS_TO_COLLECT 10

- (void) runCollector:(CCLayer *) layer {
   /* NSLog(@"------------------------------------------------");
    NSLog(@"sprite to add : %i", collector.spriteToAdd.count);
    NSLog(@"sprite to remove : %i", collector.spriteToRemove.count);
    NSLog(@"particle to add : %i", collector.particleSystemToAdd.count);
    NSLog(@"particle to remove : %i", collector.spriteToRemove.count);
    */
    
    NSInteger i = 0;
    while (i < NB_MAX_ELEMENTS_TO_COLLECT && collector.spriteToRemove.count > 0) {
        PhysicSprite *sprite = [collector.spriteToRemove dequeue];
        cpSpaceRemoveShape(self.space, sprite.shape);
        if(cpSpaceContainsBody(self.space, sprite.body)) {
            cpSpaceRemoveBody(self.space, sprite.body);
        }
        [sprite hasBeenRemovedFromSpace:self.space];
        ++i;
    }
    
    i = 0;
    while (i < NB_MAX_ELEMENTS_TO_COLLECT && collector.spriteToAdd.count > 0) {
        PhysicSprite *sprite = [collector.spriteToAdd dequeue];
        if(!cpBodyIsStatic(sprite.body)) {
            cpSpaceAddBody(self.space, sprite.body);
        }
        cpSpaceAddShape(self.space, sprite.shape);
        [sprite hasBeenAddedToSpace:self.space managedByLayer:layer];
        ++i;
    }
    
    i = 0;
    while (i < NB_MAX_ELEMENTS_TO_COLLECT && collector.particleSystemToRemove.count > 0) {
        PhysicParticles *particle = [collector.particleSystemToRemove dequeue];
        cpSpaceRemoveShape(self.space, particle.shape);
        [particle hasBeenRemovedFromSpace:self.space];
        ++i;
    }
    
    i = 0;
    while (i < NB_MAX_ELEMENTS_TO_COLLECT && collector.particleSystemToAdd.count > 0) {
        PhysicParticles *particle = [collector.particleSystemToAdd dequeue];
        cpSpaceAddShape(self.space, particle.shape);
        [particle hasBeenAddedToSpace:self.space managedByLayer:layer];
        ++i;
    }
    
    //[collector clear];
}

static void updateShape(cpShape *shape, void* unused) {
    if(shape == nil || shape->body == nil || shape->data == nil) {
        return;
    }
    ((__bridge CCSprite *)shape->data).position = ccp(shape->body->p.x, shape->body->p.y);
}

- (void) updateAllShapes {
    cpSpaceEachShape(self.space, &updateShape, nil);
}

- (void) clearSpace {
	for(int i = 0; i < 4; i++) {
		cpShapeFree(_walls[i]);
	}
	cpSpaceFree(_space);
    [collector clear];
}

- (void) setUpCollisionsHandlers {
    cpSpaceAddCollisionHandler(self.space, EXPLOSION_COLLISION, BLOCK_COLLISION,
                               nil,
                               nil,//
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, EXPLOSION_COLLISION, TARGET_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, EXPLOSION_COLLISION, PLAYER_COLLISION,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, ANVIL_COLLISION, BLOCK_COLLISION,
                               nil,
                               nil,//
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, ANVIL_COLLISION, TARGET_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, ANVIL_COLLISION, PLAYER_COLLISION,
                               nil,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, ANVIL_COLLISION, BLOOD_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, BLOCK_COLLISION, TARGET_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, BLOCK_COLLISION, PLAYER_COLLISION,
                               &collisionBegins,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, BLOCK_COLLISION, BLOCK_COLLISION,
                               nil,
                               nil,//
                               &collisionPostsolve,
                               nil,nil);
    
    cpSpaceAddCollisionHandler(self.space, BLOCK_COLLISION, BLOOD_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, TARGET_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, PLAYER_COLLISION,
                               &collisionBegins,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, END_POINT_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, WALL_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, BLOOD_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, PLAYER_COLLISION, END_POINT_COLLISION,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, PLAYER_COLLISION, BLOOD_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, PLAYER_COLLISION, WALL_COLLISION,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, BLOCK_COLLISION, KAMEA_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, KAMEA_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, END_POINT_COLLISION, KAMEA_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, WALL_COLLISION, KAMEA_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, PLAYER_COLLISION, KAMEA_COLLISION,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, PLAYER_COLLISION, FIRE_BALL_COLLISION,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, EXPLOSION_COLLISION, DRUM_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, ANVIL_COLLISION, DRUM_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, BLOCK_COLLISION, DRUM_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, DRUM_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, PLAYER_COLLISION, DRUM_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, KAMEA_COLLISION, DRUM_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, DRUM_COLLISION, DRUM_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, ANVIL_COLLISION, FIRE_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, BLOCK_COLLISION, FIRE_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, FIRE_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, PLAYER_COLLISION, FIRE_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, TERRAIN_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, PLAYER_COLLISION, TERRAIN_COLLISION,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TERRAIN_COLLISION, KAMEA_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TERRAIN_COLLISION, FIRE_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TERRAIN_COLLISION, BLOOD_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, PLAYER_COLLISION, STAR_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    
    cpSpaceAddCollisionHandler(self.space, ANVIL_COLLISION, FIRE_BALL_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, BLOCK_COLLISION, FIRE_BALL_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, FIRE_BALL_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, END_POINT_COLLISION, FIRE_BALL_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, WALL_COLLISION, FIRE_BALL_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TERRAIN_COLLISION, FIRE_BALL_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, DRUM_COLLISION, FIRE_BALL_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    
    cpSpaceAddCollisionHandler(self.space, ANVIL_COLLISION, BLACK_HOLE_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, BLOCK_COLLISION, BLACK_HOLE_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, BLACK_HOLE_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, DRUM_COLLISION, BLACK_HOLE_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    
    
    cpSpaceAddCollisionHandler(self.space, ANVIL_COLLISION, BOUNCING_BALL_COLLISION,
                               nil,
                               &collisionPreSolve,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, BLOCK_COLLISION, BOUNCING_BALL_COLLISION,
                               nil,
                               &collisionPreSolve,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, BOUNCING_BALL_COLLISION,
                               nil,
                               &collisionPreSolve,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, PLAYER_COLLISION, BOUNCING_BALL_COLLISION,
                               &collisionBegins,
                               &collisionPreSolve,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, END_POINT_COLLISION, BOUNCING_BALL_COLLISION,
                               nil,
                               &collisionPreSolve,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, WALL_COLLISION, BOUNCING_BALL_COLLISION,
                               nil,
                               &collisionPreSolve,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TERRAIN_COLLISION, BOUNCING_BALL_COLLISION,
                               nil,
                               &collisionPreSolve,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, DRUM_COLLISION, BOUNCING_BALL_COLLISION,
                               nil,
                               &collisionPreSolve,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, FIRE_SENSOR, BOUNCING_BALL_COLLISION,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    
    cpSpaceAddCollisionHandler(self.space, ANVIL_COLLISION, BLOCK_ATOMIZER_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, BLOCK_COLLISION, BLOCK_ATOMIZER_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, BLOCK_ATOMIZER_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, END_POINT_COLLISION, BLOCK_ATOMIZER_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, WALL_COLLISION, BLOCK_ATOMIZER_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TERRAIN_COLLISION, BLOCK_ATOMIZER_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, DRUM_COLLISION, BLOCK_ATOMIZER_SENSOR,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    
    cpSpaceAddCollisionHandler(self.space, ANVIL_COLLISION, GRENADE_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, BLOCK_COLLISION, GRENADE_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, GRENADE_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, END_POINT_COLLISION, GRENADE_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, WALL_COLLISION, GRENADE_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TERRAIN_COLLISION, GRENADE_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, DRUM_COLLISION, GRENADE_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    
    cpSpaceAddCollisionHandler(self.space, ANVIL_COLLISION, GRENADE_FRAGMENT_COLLISION,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, BLOCK_COLLISION, GRENADE_FRAGMENT_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TARGET_COLLISION, GRENADE_FRAGMENT_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, PLAYER_COLLISION, GRENADE_FRAGMENT_COLLISION,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, END_POINT_COLLISION, GRENADE_FRAGMENT_COLLISION,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, WALL_COLLISION, GRENADE_FRAGMENT_COLLISION,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, TERRAIN_COLLISION, GRENADE_FRAGMENT_COLLISION,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, DRUM_COLLISION, GRENADE_FRAGMENT_COLLISION,
                               nil,
                               nil,
                               &collisionPostsolve,
                               nil,nil);
    cpSpaceAddCollisionHandler(self.space, GRENADE_FRAGMENT_COLLISION, GRENADE_FRAGMENT_COLLISION,
                               &collisionBegins,
                               nil,
                               nil,
                               nil,nil);
    
}




@end
