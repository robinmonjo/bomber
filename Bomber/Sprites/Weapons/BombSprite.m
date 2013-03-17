
#import "BombSprite.h"
#import "GameLayer.h"
#import "chipmunk_unsafe.h"
#import "ExplosionParticles.h"

@interface BombSprite()

-(void) blowup;

@end

@implementation BombSprite

+ (BombSprite*) init {
    return [BombSprite spriteWithFile:@"bomb2.png"];
}

-(id) initWithFile:(NSString *)file {
    
    if(self=[super initWithFile:file]) {
        
        self.body = cpBodyNewStatic();
        cpBodySetVel(self.body, cpv(20, 20));
        
        self.shape = cpCircleShapeNew(self.body, 8, cpvzero);
        cpShapeSetElasticity(self.shape, .0f);
        cpShapeSetFriction(self.shape, .0f);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, BOMB_COLLISION);
    }
    return self;
}

- (NSString *) file {
    return @"bomb2.png";
}

- (NSString *) label {
    return @"Bomb";
}

-(void) startCountDown {			
    CCFiniteTimeAction *f1 = [CCFadeTo actionWithDuration:.25 opacity:200];
    CCFiniteTimeAction *f2 = [CCFadeIn actionWithDuration:.25];
		
    CCFiniteTimeAction *wait = [CCDelayTime actionWithDuration:3];
    CCAction *blowup = [CCCallFunc actionWithTarget:self selector:@selector(blowup)];
		
    [self runAction:[CCRepeatForever actionWithAction:[CCSequence actions:f1,f2,nil]]];
    [self runAction:[CCSequence actions:wait, blowup, nil]];
}

-(void) blowup {
    [[Collector sharedInstance] addSpriteToRemove:self];
}

- (void) hasBeenRemovedFromSpace:(cpSpace *)space {
    ExplosionParticles *explosion = [ExplosionParticles initWithRadius:120];
    [explosion setPosition:self.position];
    [[Collector sharedInstance] addParticleSystemToAdd:explosion];
    [super hasBeenRemovedFromSpace:space];
}


@end
