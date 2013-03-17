
#import "BomberSprite.h"
#import "TransitionLayer.h"
#import "chipmunk_unsafe.h"

@implementation BomberSprite

@synthesize path=_path, isMoving, hasStoppedMoving, isWaitingToLaunchAWeapon;

#define VELOCITY (SCREEN_WIDTH/2)

+ (BomberSprite *) init {
    return [BomberSprite spriteWithFile:@"bomber_v3_scalled.png"];
}

-(id) initWithFile:(NSString *)file {
    
    if(self=[super initWithFile:file]) {
        
        self.path = [[NSMutableArray alloc] init];
        
        cpFloat moment = cpMomentForCircle(70, 0, 10, cpvzero);
        self.body = cpBodyNew(70, moment);
        
        self.shape = cpCircleShapeNew(self.body, 10, cpvzero);
        cpShapeSetElasticity(self.shape, 0.3f);
        cpShapeSetFriction(self.shape, 1.0f);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, PLAYER_COLLISION);
                
        isMoving = NO;
        hasStoppedMoving = NO;
        isWaitingToLaunchAWeapon = NO;
                                                    
        _pointEarnedWhenDestroyed = -1;
    }
    return self;
}

//No gravity when moving
static void zeroGravityVelocityFunc(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt) {
	cpBodyUpdateVelocity(body, cpvzero, damping, dt);
}

//Gravity when not moving
static void gravityVelocityFunc(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt) {
	cpBodyUpdateVelocity(body, cpv(0, -100), damping, dt);
}

-(void) moveToLocation {
    
    if([self.path count] == 0) {
        
        isMoving = NO;
        hasStoppedMoving = YES;
        
        //The body is re-added to the space
        self.body->velocity_func = &gravityVelocityFunc;
        
        //Apply a force calculated from p1 and p2 if more than 2 points
        CGFloat forceMultiplier = 6000.0f;
        cpVect diff = cpvsub(p1, p2);
        cpVect dir = cpvnormalize(diff);
        cpBodyApplyImpulse(self.body, cpvmult(dir,  forceMultiplier), cpvzero);
        
        return;
    }
    
    //Bomber just start moving
    if(!isMoving) {
        isMoving = YES;
        //Removing its body from the space so gravity doesn't impact on the path trajectorie
        self.body->velocity_func = &zeroGravityVelocityFunc;
    }
 
    //Getting the next position to go and removing it
    CGPoint p = [[self.path objectAtIndex:0] CGPointValue];
    [self.path removeObjectAtIndex:0];
    //Updating p1 and p2
    p2 = p1;
    p1 = p;
    
    //Calculating euclidian distance
    CGFloat dx = self.position.x - p.x;
    CGFloat dy = self.position.y - p.y;
    CGFloat distance = sqrt(dx*dx + dy*dy);
    
    //Calculating how long the move must take
    CGFloat duration = distance / VELOCITY;
    
    //Creating and running the action
    CCAction *moveAction = [CCSequence actions:                          
                       [CCMoveTo actionWithDuration:duration position:p],
                       [CCCallFunc actionWithTarget:self selector:@selector(moveToLocation)],
                       nil];

    [self runAction:moveAction];   
}


-(void) dropWeapon:(CCSprite<WeaponSpriteProtocol> *)weapon inLayer:(GameLayer*) layer {
    [weapon removeFromParentAndCleanup:NO]; //remove from the weapon layer
    
    if([weapon isKindOfClass:[AnvilSprite class]]) {
        weapon.position = self.position;
        [[Collector sharedInstance] addSpriteToAdd:(PhysicSprite*)weapon];
    }
    else if([weapon isKindOfClass:[BombSprite class]]) {
        BombSprite* bomb = (BombSprite*)weapon;
        bomb.position = self.position;
        [[Collector sharedInstance] addSpriteToAdd:(PhysicSprite*)weapon];
        [bomb startCountDown];
    }
    else if([weapon isKindOfClass:[LaunchableWeaponSprite class]]) {
        [self stopAllActions];
        isWaitingToLaunchAWeapon = YES;
    }
    else if ([weapon isKindOfClass:[BlackHoleSprite class]]) {
        weapon.position = self.position;
        [[Collector sharedInstance] addSpriteToAdd:(PhysicSprite*)weapon];
    }
}

- (void) launchWeapon:(LaunchableWeaponSprite *)launchableWeapon inDirection:(CGPoint) direction {
    isWaitingToLaunchAWeapon = NO;
    launchableWeapon.position = self.position;
    launchableWeapon.direction = direction;
    [[Collector sharedInstance] addSpriteToAdd:launchableWeapon];
    if (isMoving) {
        [self moveToLocation];
    }
}

-(void) hasCollide {
    if(!isMoving) return;
    [self stopAllActions];
    [self.path removeAllObjects];
    [self moveToLocation]; //to do a proper stop :-)
}

@end
