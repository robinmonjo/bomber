
#import "KameaSprite.h"
#import "GameLayer.h"
#import "ParticlesManager.h"

@implementation KameaSprite

+(KameaSprite*) init {
    return [KameaSprite spriteWithFile:@"kamea.png"];
}

- (id) initWithFile:(NSString *)file {
    
    if(self=[super initWithFile:file]) {
        
        self.body = cpBodyNew(100, INFINITY);
        self.body->velocity_func = &noGravityVelocityFunc;
        
        self.shape = cpCircleShapeNew(self.body, 5, cpvzero);

        resistance = 120;
        
        cpShapeSetElasticity(self.shape, .1f);
        cpShapeSetFriction(self.shape, .3f);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, KAMEA_COLLISION);
    }
    return self;
}


- (NSString *) file {
    return @"kamea.png";
}

- (NSString *) label {
    return @"Kamea";
}

- (void) lowerResistanceBy:(float) damage {
    
    if(resistance <= 0) return;
    
    resistance -= damage;

    if(resistance <= 0.0) {
        CCParticleSystemQuad *particles = [[ParticlesManager sharedInstance] getParticle:@"KameaParticle.plist"];
        particles.position = self.position;
        particles.scale = 0.5;
        
        [self.parent addChild:particles z:100];
        
        [[Collector sharedInstance] addSpriteToRemove:self];
    }
}

- (void) launch {
    cpVect dir = cpvnormalize(cpvsub(self.direction, self.position));
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage: @"kamea_streak.png"];
    streak = [CCMotionStreak streakWithFade:1 minSeg:3 width:self.contentSize.width color:ccc3(255, 255, 255) texture:texture];
    
	[self.parent addChild:streak];
    cpBodyApplyForce(self.body, cpvmult(dir, 100000), cpvzero);
}

- (void) onExit {
    if([self.parent isKindOfClass:[GameLayer class]]){
        [streak performSelector:@selector(removeFromParentAndCleanup:) withObject:nil afterDelay:2];
    }
    [super onExit];
}

- (void) setPosition:(CGPoint)position {
    [super setPosition:position];
    [streak setPosition:self.position];
}

@end
