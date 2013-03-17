
#import "DrumSprite.h"
#import "GameLayer.h"
#import "chipmunk_unsafe.h"
#import "FireParticles.h"
#import "ExplosionParticles.h"

@interface DrumSprite()

//Post step methods
static void postStepExplode(cpSpace *space, DrumSprite *_self, void *unused);
static void postStepRemoveAfterExplosion(cpSpace *space, DrumSprite *_self, void *unused);
static void postStepRemoveNoExplosion(cpSpace *space, DrumSprite *_self, void *unused);

@end

@implementation DrumSprite

@synthesize explodeShape;

@synthesize explosionParticles=_explosionParticles, fireParticles=_fireParticles;

+(DrumSprite*) init {
    return [DrumSprite spriteWithFile:@"drum.png"];
}

-(id) initWithFile:(NSString *)file {
    if(self=[super initWithFile:file]) {
        
        //row 1, col 1
        int num = 4;
        CGPoint verts[] = {
            cpv(-6.0f, -8.0f),
            cpv(-6.0f, 7.0f),
            cpv(5.0f, 7.0f),
            cpv(5.0f, -8.0f)
        };
                
        cpFloat moment = cpMomentForPoly(100, num, verts, cpvzero);
        self.body = cpBodyNew(100, moment);
        
        self.shape = cpPolyShapeNew(self.body, num, verts, cpvzero);
        cpShapeSetElasticity(self.shape, .1f);
        cpShapeSetFriction(self.shape, .3f);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, DRUM_COLLISION);
        
        hasExplode = NO;
        
        self.fireParticles = [FireParticles init];
        self.explosionParticles = [ExplosionParticles initWithRadius:50];
        
    }
    return self;
}

- (void) explode {
    if(hasExplode) return; //will explode in a post step method
    
    hasExplode = YES;
    
    [[Collector sharedInstance] addSpriteToRemove:self];
    
    [self.fireParticles setPosition:CGPointMake(self.position.x, self.position.y - self.contentSize.height/2)];
    [[Collector sharedInstance] addParticleSystemToAdd:self.fireParticles];
    
    [self.explosionParticles setPosition:self.position];
    [[Collector sharedInstance] addParticleSystemToAdd:self.explosionParticles];
    
}


@end
