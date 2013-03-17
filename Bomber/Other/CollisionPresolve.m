#import "GameLayer.h"

#define BOUNCING_BALL_ELASTICITY 1.0f

static int ANVIL_COLLISION_presolve_with(cpShape *anvilShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BOUNCING_BALL_COLLISION:
            cpArbiterSetElasticity(arb, BOUNCING_BALL_ELASTICITY);
            if(!cpArbiterIsFirstContact(arb)) return cpTrue;
            [((__bridge BouncingBallSprite *)b->data) hasBounced];
            return cpTrue;
            break;
        default:
            NSLog(@"collision presolve with ANVIL NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int BLOCK_COLLISION_presolve_with(cpShape *anvilShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BOUNCING_BALL_COLLISION:
            cpArbiterSetElasticity(arb, BOUNCING_BALL_ELASTICITY);
            if(!cpArbiterIsFirstContact(arb)) return cpTrue;
            [((__bridge BouncingBallSprite *)b->data) hasBounced];
            return cpTrue;
            break;
        default:
            NSLog(@"collision presolve with BLOCK NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int TARGET_COLLISION_presolve_with(cpShape *anvilShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BOUNCING_BALL_COLLISION:
            cpArbiterSetElasticity(arb, BOUNCING_BALL_ELASTICITY);
            if(!cpArbiterIsFirstContact(arb)) return cpTrue;
            [((__bridge BouncingBallSprite *)b->data) hasBounced];
            return cpTrue;
            break;
        default:
            NSLog(@"collision presolve with TARGET NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int PLAYER_COLLISION_presolve_with(cpShape *anvilShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BOUNCING_BALL_COLLISION:
            cpArbiterSetElasticity(arb, BOUNCING_BALL_ELASTICITY);
            if(!cpArbiterIsFirstContact(arb)) return cpTrue;
            [((__bridge BouncingBallSprite *)b->data) hasBounced];
            return cpTrue;
            break;
        default:
            NSLog(@"collision presolve with PLAYER NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int END_POINT_COLLISION_presolve_with(cpShape *anvilShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BOUNCING_BALL_COLLISION:
            cpArbiterSetElasticity(arb, BOUNCING_BALL_ELASTICITY);
            if(!cpArbiterIsFirstContact(arb)) return cpTrue;
            [((__bridge BouncingBallSprite *)b->data) hasBounced];
            return cpTrue;
            break;
        default:
            NSLog(@"collision presolve with END_POINT NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int WALL_COLLISION_presolve_with(cpShape *anvilShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BOUNCING_BALL_COLLISION:
            cpArbiterSetElasticity(arb, BOUNCING_BALL_ELASTICITY);
            if(!cpArbiterIsFirstContact(arb)) return cpTrue;
            [((__bridge BouncingBallSprite *)b->data) hasBounced];
            return cpTrue;
            break;
        default:
            NSLog(@"collision presolve with WALL NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int TERRAIN_COLLISION_presolve_with(cpShape *anvilShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BOUNCING_BALL_COLLISION:
            cpArbiterSetElasticity(arb, BOUNCING_BALL_ELASTICITY);
            if(!cpArbiterIsFirstContact(arb)) return cpTrue;
            [((__bridge BouncingBallSprite *)b->data) hasBounced];
            return cpTrue;
            break;
        default:
            NSLog(@"collision presolve with TERRAIN NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int DRUM_COLLISION_presolve_with(cpShape *anvilShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BOUNCING_BALL_COLLISION:
            cpArbiterSetElasticity(arb, BOUNCING_BALL_ELASTICITY);
            if(!cpArbiterIsFirstContact(arb)) return cpTrue;
            [((__bridge BouncingBallSprite *)b->data) hasBounced];
            return cpTrue;
            break;
        default:
            NSLog(@"collision presolve with DRUM NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int collisionPreSolve(cpArbiter *arb, cpSpace *space, void *data) {

    CP_ARBITER_GET_SHAPES(arb, a, b);
    
    if(!cpArbiterIsFirstContact(arb)) return cpTrue;
    
    switch (cpShapeGetCollisionType(a)) {
        case ANVIL_COLLISION:
            return ANVIL_COLLISION_presolve_with(a, b, arb);
            break;
        case BLOCK_COLLISION:
            return BLOCK_COLLISION_presolve_with(a, b, arb);
            break;
        case TARGET_COLLISION:
            return TARGET_COLLISION_presolve_with(a, b, arb);
            break;
        case PLAYER_COLLISION:
            return PLAYER_COLLISION_presolve_with(a, b, arb);
            break;
        case END_POINT_COLLISION:
            return END_POINT_COLLISION_presolve_with(a, b, arb);
            break;
        case WALL_COLLISION:
            return WALL_COLLISION_presolve_with(a, b, arb);
            break;
        case TERRAIN_COLLISION:
            return TERRAIN_COLLISION_presolve_with(a, b, arb);
            break;
        case DRUM_COLLISION:
            return DRUM_COLLISION_presolve_with(a, b, arb);
            break;
        default:
            NSLog(@"collision presolve NOT MANAGED");
            return cpTrue;
            break;
    }

    

}