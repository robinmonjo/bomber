//
//  BlackHoleSprite.m
//  Bomber
//
//  Created by Robin Monjo on 9/21/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "BlackHoleSprite.h"
#import "BomberSprite.h"

@implementation BlackHoleSprite

+(BlackHoleSprite *) init {
    
    return [BlackHoleSprite spriteWithFile:@"fire_ball.png"];
}

- (id) initWithFile:(NSString *)file {
    
    if(self=[super initWithFile:file]) {
        
        self.body = cpBodyNewStatic();
        
        self.shape = cpCircleShapeNew(self.body, 30, cpvzero);
        
        cpShapeSetSensor(self.shape, cpTrue);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, BLACK_HOLE_SENSOR);
    }
    return self;
}

- (NSString *) file {
    return @"fire_ball.png";
}

- (NSString *) label {
    return @"Black Hole";
}

CGPoint gravitiPosition;

//Gravity when not moving
static void normalGravityVelocityFunc(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt) {
	cpBodyUpdateVelocity(body, cpv(0, -100), damping, dt);
}

static void radialGravityVelocityFunc(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt) {
    cpVect p = cpvsub(gravitiPosition, body->p);
    cpVect g = p;
    cpBodyUpdateVelocity(body, g, damping, dt);
}

static void startRadialGravity(cpShape *shape, cpFloat distance, cpVect point, void *unused) {
    if (shape->data && !cpBodyIsStatic(shape->body)) {
        if ([(__bridge PhysicSprite *)shape->data isKindOfClass:[BomberSprite class]]) {
            if (((__bridge BomberSprite *)shape->data).isMoving) {
                return; //bomber moving is not affected but bomber not moving is
            }
        }
        shape->body->velocity_func = &radialGravityVelocityFunc;
    }
}

static void stopRadialGravity(cpShape *shape, cpFloat distance, cpVect point, void *unused) {
    if (shape->data && !cpBodyIsStatic(shape->body)) {
        if ([(__bridge PhysicSprite *)shape->data isKindOfClass:[BomberSprite class]]) {
            if (((__bridge BomberSprite *)shape->data).isMoving) {
                return; //bomber moving is not affected but bomber not moving is
            }
        }
        shape->body->velocity_func = &normalGravityVelocityFunc;
    }
}


- (void) hasBeenAddedToSpace:(cpSpace *)space managedByLayer:(CCLayer *)layer {
    [super hasBeenAddedToSpace:space managedByLayer:layer];
    
    _emitter = [[ParticlesManager sharedInstance] getParticle:@"BlackHoleParticle.plist"];
    _emitter.position = self.position;
    [layer addChild:_emitter];
    //make all shapes around gravite
    gravitiPosition = self.position;
    
    cpSpaceNearestPointQuery(space, self.position, 100, CP_ALL_LAYERS, CP_NO_GROUP, &startRadialGravity, nil);
    
    _space = space;
    
    [self performSelector:@selector(disappear) withObject:nil afterDelay:2];
}

- (void) disappear {
    
    cpSpaceNearestPointQuery(_space, self.position, 100, CP_ALL_LAYERS, CP_NO_GROUP, &stopRadialGravity, nil);
    CCFiniteTimeAction *scaleDown = [CCScaleTo actionWithDuration:0.3 scale:.0f];
    CCAction *sequence = [CCSequence actionOne:scaleDown two:[CCCallFunc actionWithTarget:_emitter selector:@selector(removeFromParentAndCleanup:)]];
    
    
    [_emitter runAction:sequence];
    
    [[Collector sharedInstance] addSpriteToRemove:self];

}

@end
