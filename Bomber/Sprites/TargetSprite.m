
#import "TargetSprite.h"
#import "BubbleLayer.h"
#import "chipmunk_unsafe.h"
#import "BloodParticles.h"

@interface TargetSprite()

static void postStepRemove(cpSpace *space, TargetSprite *_self, void* unused);

@end

@implementation TargetSprite

+ (TargetSprite*) init {
    return [TargetSprite spriteWithFile:@"elephant.png"];
}


-(id) initWithFile:(NSString *)file {
    
    if(self=[super initWithFile:file]) {
        cpFloat moment = cpMomentForCircle(70, 0, 10, cpvzero);
        
        self.body = cpBodyNew(70, moment);
        
        self.shape = cpCircleShapeNew(self.body, 10, cpvzero);
        cpShapeSetElasticity(self.shape, .3f);
        cpShapeSetFriction(self.shape, 1.0f);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, TARGET_COLLISION);
        
        resistance = 15;
        
        self.pointEarnedWhenDestroyed = 200;
    }
    return self;
}

-(void) showDamages:(float)damage {
    CCMenuItemFont *font = [CCMenuItemFont itemWithString:[NSString stringWithFormat:@"%.2f",damage]];
    [font setFontSize:10];
    font.scale = 0;
    font.position = self.position;
    CCAction *scale = [CCScaleTo actionWithDuration:1 scale:1];
    float y = (arc4random() % 100)+30;
    CCAction *move = [CCMoveBy actionWithDuration:1 position:CGPointMake(0, y)];
    CCFiniteTimeAction *wait = [CCDelayTime actionWithDuration:2];
    CCFiniteTimeAction *removeFromParent = [CCCallFunc actionWithTarget:font selector:@selector(removeFromParentAndCleanup:)];
    [self.parent addChild:font];
    [font runAction:scale];
    [font runAction:move];
    [font runAction:[CCSequence actions:wait, removeFromParent, nil]];
                            
}

-(void) addDamage:(CGFloat) damage {

    if(resistance <= 0) return; //is already waiting to be removed from the space in the next post step callback
    
    [self showDamages:damage];
    resistance -= damage;
	if (resistance < 0) {
        
        BloodParticles *particles = [BloodParticles init];
        particles.position = self.position;
        [[Collector sharedInstance] addParticleSystemToAdd:particles];
        [[Collector sharedInstance] addSpriteToRemove:self];
        
        [self showPointEarned];
	}
}


-(void) moquePlayer {
    BubbleLayer *bubble = [[BubbleLayer alloc] initWithText:@"Gotcha" andSprite:nil];
    [bubble setPosition:CGPointMake(self.position.x, self.position.y + self.boundingBox.size.height /2)];
    [self.parent addChild:bubble];
    [bubble show];
    [bubble performSelector:@selector(hideAndRemove) withObject:nil afterDelay:2];
}


@end
