
#import "EndPointSprite.h"

@implementation EndPointSprite

+(EndPointSprite*) init {
    return [EndPointSprite spriteWithFile:@"cloud.png"];
}

#define CLOUD_WIDTH 30

-(id) initWithFile:(NSString *)file {
    if(self=[super initWithFile:file]) {
        
        self.body = cpBodyNewStatic();
        
        self.shape = cpSegmentShapeNew(self.body, cpv(-CLOUD_WIDTH/2, 0), cpv(CLOUD_WIDTH/2, 0), 3);
        cpShapeSetElasticity(self.shape, .5f);
        cpShapeSetFriction(self.shape, 1.0f);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, END_POINT_COLLISION);
    }
    return self;
}

@end
