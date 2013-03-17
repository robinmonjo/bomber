
#import "StarSprite.h"
#import "ParticlesManager.h"
#import "GameLayer.h"

@implementation StarSprite

+(StarSprite*) init {
    return [StarSprite spriteWithFile:@"star.png"];
}

-(id) initWithFile:(NSString *)file {
    if(self=[super initWithFile:file]) {
        
        self.body = cpBodyNewStatic();
        
        //row 1, col 1
        int num = 8;
        CGPoint verts[] = {
            cpv(-6.0f, -9.0f),
            cpv(-9.0f, 1.0f),
            cpv(-9.0f, 2.0f),
            cpv(-1.0f, 8.0f),
            cpv(0.0f, 8.0f),
            cpv(8.0f, 2.0f),
            cpv(8.0f, 1.0f),
            cpv(5.0f, -9.0f)
        };
    
        self.shape = cpPolyShapeNew(self.body, num, verts, cpvzero);
        cpShapeSetSensor(self.shape, true);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, STAR_SENSOR);
        
        self.pointEarnedWhenDestroyed = 500;
    
    }
    return self;
}

- (void) hasBeenTaken {
    
    [[Collector sharedInstance] addSpriteToRemove:self];
    
    GameLayer *gameLayer = (GameLayer*)self.parent;
    [gameLayer starCaught];
    
    CCParticleSystemQuad *emitter = [[ParticlesManager sharedInstance] getParticle:@"StarParticle.plist"];
    emitter.position = self.position;
    [self.parent addChild:emitter];
    
    [self showPointEarned];
}


@end
