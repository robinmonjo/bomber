#import "GameLayer.h"

static void collisionSeparates(cpArbiter *arb, cpSpace *space, void *data) {
        
    CP_ARBITER_GET_SHAPES(arb, a, b);
        
    if(a->collision_type == BLOCK_COLLISION && b->collision_type == PLAYER_COLLISION) {
        NSLog(@"Separate");
        cpBodyResetForces(a->body);
    }
    
}
