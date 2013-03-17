//
//  ExplosifPatchSprite.m
//  Bomber
//
//  Created by Robin Monjo on 10/3/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "BlockAtomiserSprite.h"
#import "BreakableBlockSprite.h"

@implementation BlockAtomiserSprite

+ (BlockAtomiserSprite *) init {
    return [BlockAtomiserSprite spriteWithFile:@"explosif_patch.png"];
}

- (id) initWithFile:(NSString *)filename {
    
    if (self = [super initWithFile:filename]) {
        
        self.body = cpBodyNew(10, INFINITY);
        self.body->velocity_func = &noGravityVelocityFunc;
        
        self.shape = cpCircleShapeNew(self.body, 5, cpvzero);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetSensor(self.shape, cpTrue);
        cpShapeSetCollisionType(self.shape, BLOCK_ATOMIZER_SENSOR);
        
    }
    return self;
}

- (NSString *) file {
    return @"explosif_patch.png";
}

- (NSString *) label {
    return @"Block Atomizer";
}

- (void) launch {
    cpVect dir = cpvnormalize(cpvsub(self.direction, self.position));
    cpBodyApplyForce(self.body, cpvmult(dir, 100000), cpvzero);
}

- (void) hitBlock:(BlockSprite *) block {
    
    if ([block isKindOfClass:[BreakableBlockSprite class]]) {
        [((BreakableBlockSprite *)block) atomizeBlock];
    }
    [[Collector sharedInstance] addSpriteToRemove:self];
}

- (void) didNotHitBlock {
    
    [[Collector sharedInstance] addSpriteToRemove:self];
}


@end
