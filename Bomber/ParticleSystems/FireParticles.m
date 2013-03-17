
#import "FireParticles.h"

@implementation FireParticles

+ (FireParticles*) init {
    return [[FireParticles alloc] init];
}

- (id) init {
    if (self = [super initWithFile:@"FireParticle.plist"]) {
        
        //row 1, col 1
        int num = 4;
        CGPoint verts[] = {
            cpv(-21.5f, -14.0f),
            cpv(-21.5f, 14.0f),
            cpv(21.5f, 14.0f),
            cpv(21.5f, -14.0f)
        };
        
        self.body = cpBodyNew(10, INFINITY);
        
        self.shape = cpPolyShapeNew(self.body, num, verts, cpvzero);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetSensor(self.shape, true);
        cpShapeSetCollisionType(self.shape, FIRE_SENSOR);
    }
    return self;
}


/*- (void) onExit {
    cpSpaceAddPostStepCallback(activeSpace(), (cpPostStepFunc)postStepRemove, shape, nil);
    [super onExit];
}*/


/*- (void) draw {
    [super draw];
    int num = 4;
    CGPoint verts[] = {
        cpv(-21.5f, -5.0f),
        cpv(-21.5f, 10.0f),
        cpv(21.5f, 10.0f),
        cpv(21.5f, -5.0f)
    };
    glLineWidth(3.0f);
    ccDrawPoly(verts, num, YES);
}*/




@end
