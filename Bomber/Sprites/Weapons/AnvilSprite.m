
#import "AnvilSprite.h"
#import "GameLayer.h"

@implementation AnvilSprite

+(AnvilSprite*) init {
    
    return [AnvilSprite spriteWithFile:@"anvil.png"];
}

-(id) initWithFile:(NSString *)file {
    
    if(self=[super initWithFile:file]) {
        
        //row 1, col 1
        int num = 6;
        CGPoint verts[] = {
            cpv(-3.0f, -5.0f),
            cpv(-10.0f, 2.0f),
            cpv(-5.0f, 3.0f),
            cpv(10.0f, 4.0f),
            cpv(10.0f, 3.0f),
            cpv(3.0f, -5.0f)
        };
        cpFloat moment = cpMomentForPoly(100, num, verts, cpvzero);
        
        self.body = cpBodyNew(100, moment);
        
        self.shape = cpPolyShapeNew(self.body, num, verts, cpvzero);
        cpShapeSetElasticity(self.shape, .1f);
        cpShapeSetFriction(self.shape, .3f);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, ANVIL_COLLISION);
    }
    return self;
}

- (NSString *) file {
    return @"anvil.png";
}

- (NSString *) label {
    return @"Anvil";
}



@end
