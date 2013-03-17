
#import "BlockSprite.h"

@implementation BlockSprite

-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect mass:(cpFloat) mass {
    
    if(self=[super initWithTexture:texture rect:rect]) {
        
        self.body = cpBodyNew(mass, cpMomentForBox(rect.size.width, rect.size.height, mass));
        
        //Converting points in chipmunk coordinates
        CGPoint p1 = CGPointMake(-rect.size.width/2, -rect.size.height/2);
        CGPoint p2 = CGPointMake(-rect.size.width/2, +rect.size.height/2);
        CGPoint p3 = CGPointMake(+rect.size.width/2, +rect.size.height/2);
        CGPoint p4 = CGPointMake(+rect.size.width/2, -rect.size.height/2);
        
        //body->v_limit = 250;
        
        CGPoint verts[] = {p1, p2, p3, p4};
            
        self.shape = cpPolyShapeNew(self.body, 4, verts, cpvzero);
        cpShapeSetElasticity(self.shape, .1f);
        cpShapeSetFriction(self.shape, 1.0f);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, BLOCK_COLLISION);

    }
    ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
    [self.texture setTexParameters:&tp];
    
    return self;
}


/*
 A classic block can't be divided
*/

- (void) impactAtPoint:(CGPoint) p withDamage:(float) damage {
    return;
}

- (BOOL) canBeDivided {
    return NO;
}

//No gravity when moving
static void noGravityVelocityFunc(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt) {
	cpBodyUpdateVelocity(body, cpvzero, damping, dt);
}

- (void) makeBlockPerformAction:(CCAction *)action {
    
    NSAssert(![self canBeDivided], @"shouldn't use a breakable block for movement");
    
    self.body->velocity_func = &noGravityVelocityFunc;
    cpBodySetMass(self.body, INFINITY);
    [self runAction:action];
}

@end
