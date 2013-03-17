

#import "BloodParticles.h"

@implementation BloodParticles

+ (BloodParticles*) init {
    return [[BloodParticles alloc] init];
}

- (id) init {
    if (self = [super initWithFile:@"BloodParticle.plist"]) {

        particleSystem.scale = 1;
        
        self.body = cpBodyNew(10, INFINITY);
        
        self.shape = cpCircleShapeNew(self.body, 20, cpvzero);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetSensor(self.shape, cpTrue);
        cpShapeSetCollisionType(self.shape, BLOOD_SENSOR);
    }
    return self;
}


@end
