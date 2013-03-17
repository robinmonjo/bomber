
#import "PhysicSprite.h"
#import "GameLayer.h"
#import "ParticlesManager.h"

@implementation PhysicSprite

@synthesize body=_body, shape=_shape, pointEarnedWhenDestroyed=_pointEarnedWhenDestroyed;

- (id) init {
    if (self = [super init]) {
        _pointEarnedWhenDestroyed = 0; //by default, 0 points earned when destroyed
    }
    return self;
}

- (void) setPosition:(CGPoint)position {
    [super setPosition:position];
    cpBodySetPos(self.body, position);
    [self setRotation: (float) CC_RADIANS_TO_DEGREES(-self.body->a)];
}

- (void) setRotation:(float)rotation {
    [super setRotation:rotation];
    self.body->a = (float) CC_DEGREES_TO_RADIANS(-self.rotation);
}

- (void) hasBeenAddedToSpace:(cpSpace *)space managedByLayer:(CCLayer *)layer {
    [layer addChild:self];
}

- (void) hasBeenRemovedFromSpace:(cpSpace *)space {
    [self removeFromParentAndCleanup:YES];
}

- (void) setBloodSplashAtPoint:(CGPoint) p withNormal:(cpVect) n {
    
    CCSprite *blood = [CCSprite spriteWithFile:@"Blood.png"];
    CGFloat minSide = self.contentSize.width > self.contentSize.height ? self.contentSize.height : self.contentSize.width;
    
    CGFloat scaleFactor = minSide / blood.contentSize.width;

    if (scaleFactor > 1) {
        scaleFactor = 1;
    }
    
    blood.position = CGPointMake((p.x + self.contentSize.width/2) - blood.contentSize.width * scaleFactor * .5f * n.x,
                                 (p.y + self.contentSize.height/2) - blood.contentSize.height * scaleFactor * .5f * n.y);
    blood.scale = scaleFactor;
    
    [self addChild:blood];
}

- (void) setSmokeAtPoint:(CGPoint) p withNormal:(cpVect) n {
    
    CCParticleSystemQuad *smoke = [[ParticlesManager sharedInstance] getParticle:@"SmokeParticle.plist"];

    CGFloat scaleFactor = 0.5;
    smoke.position = CGPointMake((p.x + self.contentSize.width/2) - smoke.contentSize.width * scaleFactor,
                                 (p.y + self.contentSize.height/2) - smoke.contentSize.height * scaleFactor);
    smoke.scale = scaleFactor;
    
    [self addChild:smoke z:100];
}

- (void) removeAfterSucked {
    [[Collector sharedInstance] addSpriteToRemove:self];
    [self showPointEarned];
}

- (void) suckedByBlackHoleWithCenter:(CGPoint)blackHoleCenter {
    CCFiniteTimeAction *scaleDown = [CCScaleTo actionWithDuration:0.60 scale:.0f];
    CCFiniteTimeAction *moveToCenter = [CCMoveTo actionWithDuration:0.60 position:blackHoleCenter];
    CCFiniteTimeAction *scaleAndMove = [CCSpawn actionOne:scaleDown two:moveToCenter];
    CCAction *sequence = [CCSequence actionOne:scaleAndMove two:[CCCallFunc actionWithTarget:self selector:@selector(removeAfterSucked)]];
    [self runAction:sequence];
}

- (void) showPointEarned {
    
 /*   CCMenuItemFont *font = [CCMenuItemFont itemWithString:[NSString stringWithFormat:@"%i", self.pointEarnedWhenDestroyed]];
    [font setFontSize:15];
    font.color = ccc3(255, 84, 10);
    font.scale = 0;
    font.position = self.position;
    CCAction *scale = [CCScaleTo actionWithDuration:1 scale:1];
    CGFloat y = (arc4random() % 100)+30;
    CCAction *move = [CCMoveBy actionWithDuration:1 position:CGPointMake(0, y)];
    CCFiniteTimeAction *wait = [CCDelayTime actionWithDuration:2];
    CCFiniteTimeAction *removeFromParent = [CCCallFunc actionWithTarget:font selector:@selector(removeFromParentAndCleanup:)];
    [self.parent addChild:font];
    [font runAction:scale];
    [font runAction:move];
    [font runAction:[CCSequence actions:wait, removeFromParent, nil]];
    
    [Collector sharedInstance].pointEarned += self.pointEarnedWhenDestroyed; */
}

- (void) onExit {
        
    if ([self.parent isKindOfClass:[GameLayer class]]) {
        //removed from physic layer,
        cpShapeFree(_shape);
        cpBodyFree(_body);
    }
    [super onExit];
}

@end
