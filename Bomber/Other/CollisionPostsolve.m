#include "GameLayer.h"

static float getDamage(cpArbiter *arb) {
    
    CP_ARBITER_GET_SHAPES(arb, a, b);
    
    float damage;
    
    if(b->collision_type == EXPLOSION_COLLISION || a->collision_type == EXPLOSION_COLLISION) {
        /*
         Bombs have a static body so they don't generate any impulse. So we need a
         special calculation for the damage:
         */
        //Calcul a bias according to the distance from the bomb. 18 is radius of target + radius of bomb shape
        //cpCircleShapeRadius(b) is the radius of the eplosion
        //return a bias between 1..0
        
        cpShape *explosion, *target;
        
        if(a->collision_type == EXPLOSION_COLLISION) {
            explosion = a;
            target = b;
        }
        else {
            explosion = b;
            target = a;
        }
        
        
        int i = cpArbiterGetCount(arb);
        cpVect n = cpArbiterGetNormal(arb, i-1);
        cpVect p = cpArbiterGetPoint(arb, i-1);
        cpFloat d = cpArbiterGetDepth(arb, i-1);
        
        float imp = cpvdist(target->body->p, cpvadd(p, cpvmult(n, d/2)));
        
        float bias = 1 - (cpvdist(explosion->body->p, target->body->p)-(imp+9)) / cpCircleShapeGetRadius(explosion);
        
        damage = 30.0f * bias;
    }
    else if(b->collision_type == KAMEA_COLLISION && cpBodyIsStatic(a->body)) {
        damage = 200; //wall ou end_point, remove kamea (200 is the initial resistance of a kamea)
        
    }
    else {
        damage = cpvlength(cpArbiterTotalImpulse(arb))/500.0f;
        damage = (damage > 2) ? damage : 0;
    }
    
    return damage;
}

static void applyDamageToBlock(BlockSprite * block, cpArbiter *arb) {
    /*
     The normal of an impact changes according to the order of the collision type:
        if CP_ARBITER_GET_SHAPES(arb, a, b) gives 'a' is the sprite overlapping (e.g: explosion)
        do : cpBodyWorld2Local(block.body, cpvadd(p, cpvmult(n, d/2))
        else do : cpBodyWorld2Local(block.body, cpvsub(p, cpvmult(n, d/2))
    */
    if(![block canBeDivided]) return;
    
    int i = cpArbiterGetCount(arb);
    cpVect n = cpArbiterGetNormal(arb, i-1);
    cpVect p = cpArbiterGetPoint(arb, i-1);
    cpFloat d = cpArbiterGetDepth(arb, i-1);

    [block impactAtPoint:cpBodyWorld2Local(block.body, cpvadd(p, cpvmult(n, d/2)))
           withDamage:getDamage(arb)];    
}

static void applyDamageToTarget(TargetSprite* target, cpArbiter *arb) {
    CGFloat damage = getDamage(arb);
    if(damage >= 1.0)
        [target addDamage:damage];
}

static void applyDamageToKamea(KameaSprite* kamea, cpArbiter *arb) {
    float damage = getDamage(arb);
    [kamea lowerResistanceBy:damage];
}

static void EXPLOSION_COLLISION_postSolve_with(cpShape *explosionShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BLOCK_COLLISION: {
            BlockSprite *block = (__bridge BlockSprite*)b->data;
            applyDamageToBlock(block, arb);
            break;
        }
        case TARGET_COLLISION: {
            TargetSprite *target = (__bridge TargetSprite*)b->data;
            applyDamageToTarget(target, arb);
            break;
        }
        case DRUM_COLLISION:
            if(getDamage(arb) > 2) {
                [((__bridge DrumSprite*)b->data) explode];
            }
            break;
        default:
            NSLog(@"POSTSOLVE COLLISION WITH EXPLOSION NOT MANAGED");
            break;
    }
}

static void ANVIL_COLLISION_postSolve_with(cpShape *anvilShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BLOCK_COLLISION: {
            BlockSprite *block = (__bridge BlockSprite*)b->data;
            applyDamageToBlock(block, arb);
            break;
        }
        case TARGET_COLLISION: {
            TargetSprite *target = (__bridge TargetSprite*)b->data;
            applyDamageToTarget(target, arb);
            break;
        }
        case DRUM_COLLISION:
            if(getDamage(arb) > 2)
                [((__bridge DrumSprite*)b->data) explode];
            break;
        case FIRE_BALL_COLLISION: {
            FireBallSprite *fireBall = (__bridge FireBallSprite *)b->data;
            [fireBall hasCollide];
            break;
        }
        case GRENADE_COLLISION: {
            [((__bridge GrenadeSprite *)b->data) fragment];
            break;
        }
        default:
            NSLog(@"POSTSOLVE COLLISION WITH ANVIL NOT MANAGED");
            break;
    }
}

static void BLOCK_COLLISION_postSolve_with(cpShape *blockShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BLOCK_COLLISION: {
            BlockSprite *block1 = (__bridge BlockSprite*)blockShape->data;
            BlockSprite *block2 = (__bridge BlockSprite*)b->data;
            applyDamageToBlock(block1, arb);
            applyDamageToBlock(block2, arb);
            break;
        }
        case TARGET_COLLISION: {
            BlockSprite *block = (__bridge BlockSprite*)blockShape->data;
            TargetSprite *target = (__bridge TargetSprite*)b->data;
            applyDamageToBlock(block, arb);
            applyDamageToTarget(target, arb);
            break;
        }
        case PLAYER_COLLISION: {
            BlockSprite *block = (__bridge BlockSprite*)blockShape->data;
            applyDamageToBlock(block, arb);
            break;
        }
        case KAMEA_COLLISION: {
            BlockSprite *block = (__bridge BlockSprite*)blockShape->data;
            KameaSprite *kamea = (__bridge KameaSprite*)b->data;
            applyDamageToBlock(block, arb);
            applyDamageToKamea(kamea, arb);
            break;
        }
        case DRUM_COLLISION:
            if(getDamage(arb) > 1)
                [((__bridge DrumSprite*)b->data) explode];
            break;
        case FIRE_BALL_COLLISION: {
            FireBallSprite *fireBall = (__bridge FireBallSprite *)b->data;
            [fireBall hasCollide];
            BlockSprite *block = (__bridge BlockSprite*)blockShape->data;
            applyDamageToBlock(block, arb);
            break;
        }
        case BOUNCING_BALL_COLLISION: {
            BlockSprite *block = (__bridge BlockSprite*)blockShape->data;
            applyDamageToBlock(block, arb);
            break;
        }
        case GRENADE_COLLISION: {
            BlockSprite *block = (__bridge BlockSprite*)blockShape->data;
            applyDamageToBlock(block, arb);
            [((__bridge GrenadeSprite *)b->data) fragment];
            break;
        }
        case GRENADE_FRAGMENT_COLLISION: {
            BlockSprite *block = (__bridge BlockSprite*)blockShape->data;
            applyDamageToBlock(block, arb);
            [((__bridge GrenadeFragmentSprite *)b->data) hasCollid];
            break;
        }
        default:
            NSLog(@"POSTSOLVE COLLISION WITH BLOCK NOT MANAGED");
            break;
    }
}

static void TARGET_COLLISION_postSolve_with(cpShape *targetShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case TARGET_COLLISION: {
            TargetSprite *target1 = (__bridge TargetSprite*)targetShape->data;
            TargetSprite *target2 = (__bridge TargetSprite*)b->data;
            applyDamageToTarget(target1, arb);
            applyDamageToTarget(target2, arb);
            break;
        }
        case PLAYER_COLLISION: {
            TargetSprite *target = (__bridge TargetSprite*)targetShape->data;
            applyDamageToTarget(target, arb);
            break;
        }
        case END_POINT_COLLISION: {
            TargetSprite *target = (__bridge TargetSprite*)targetShape->data;
            applyDamageToTarget(target, arb);
            break;
        }
        case WALL_COLLISION: {
            TargetSprite *target = (__bridge TargetSprite*)targetShape->data;
            applyDamageToTarget(target, arb);
            break;
        }
        case TERRAIN_COLLISION: {
            TargetSprite *target = (__bridge TargetSprite*)targetShape->data;
            applyDamageToTarget(target, arb);
            break;
        }
        case KAMEA_COLLISION: {
            TargetSprite *target = (__bridge TargetSprite*)targetShape->data;
            applyDamageToTarget(target, arb);
            KameaSprite *kamea = (__bridge KameaSprite*)b->data;
            applyDamageToKamea(kamea, arb);
            break;
        }
        case DRUM_COLLISION:
            if(getDamage(arb) > 2)
                [((__bridge DrumSprite*)b->data) explode];
            break;
        case FIRE_BALL_COLLISION: {
            FireBallSprite *fireBall = (__bridge FireBallSprite *)b->data;
            [fireBall hasCollide];
            TargetSprite *target = (__bridge TargetSprite*)targetShape->data;
            applyDamageToTarget(target, arb);
            break;
        }
        case BOUNCING_BALL_COLLISION: {
            TargetSprite *target = (__bridge TargetSprite*)targetShape->data;
            applyDamageToTarget(target, arb);
            break;
        }
        case GRENADE_COLLISION: {
            TargetSprite *target = (__bridge TargetSprite*)targetShape->data;
            applyDamageToTarget(target, arb);
            [((__bridge GrenadeSprite *)b->data) fragment];
            break;
        }
        case GRENADE_FRAGMENT_COLLISION: {
            TargetSprite *target = (__bridge TargetSprite*)targetShape->data;
            applyDamageToTarget(target, arb);
            [((__bridge GrenadeFragmentSprite *)b->data) hasCollid];
            break;
        }
        default:
            NSLog(@"POSTSOLVE COLLISION WITH TARGET NOT MANAGED");
            break;
    }
}

static void PLAYER_COLLISION_postSolve(cpShape *playerShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case DRUM_COLLISION:
            if(getDamage(arb) > 2)
                [((__bridge DrumSprite*)b->data) explode];
            break;
        default:
            NSLog(@"POSTSOLVE COLLISION WITH PLAYER NOT MANAGED");
            break;
    }
}

static void END_POINT_COLLISION_postSolve_with(cpShape *endPointShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case KAMEA_COLLISION: {
            KameaSprite *kamea = (__bridge KameaSprite*)b->data;
            applyDamageToKamea(kamea, arb);
            break;
        }
        case FIRE_BALL_COLLISION: {
            FireBallSprite *fireBall = (__bridge FireBallSprite *)b->data;
            [fireBall hasCollide];
            break;
        }
        case GRENADE_COLLISION: {
            [((__bridge GrenadeSprite *)b->data) fragment];
            break;
        }
        default:
            NSLog(@"POSTSOLVE COLLISION WITH ENDPOINT NOT MANAGED");
            break;
    }
}

static void WALL_COLLISION_postSolve_with(cpShape *wallShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case KAMEA_COLLISION: {
            KameaSprite *kamea = (__bridge KameaSprite*)b->data;
            applyDamageToKamea(kamea, arb);
            break;
        }
        case FIRE_BALL_COLLISION: {
            FireBallSprite *fireBall = (__bridge FireBallSprite *)b->data;
            [fireBall hasCollide];
            break;
        }
        case GRENADE_COLLISION: {
            [((__bridge GrenadeSprite *)b->data) fragment];
            break;
        }
        default:
            NSLog(@"POSTSOLVE COLLISION WITH WALL NOT MANAGED");
            break;
    }
}

static void TERRAIN_COLLISION_postSolve_with(cpShape *terrainShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case KAMEA_COLLISION:{
            KameaSprite *kamea = (__bridge KameaSprite*)b->data;
            applyDamageToKamea(kamea, arb);
            break;
        }
        case FIRE_BALL_COLLISION: {
            FireBallSprite *fireBall = (__bridge FireBallSprite *)b->data;
            [fireBall hasCollide];
            break;
        }
        case GRENADE_COLLISION: {
            [((__bridge GrenadeSprite *)b->data) fragment];
            break;
        }
        default:
            NSLog(@"POSTSOLVE COLLISION WITH TERRAIN NOT MANAGED");
            break;
    }
}

static void KAMEA_COLLISION_postSolve_with(cpShape *kameaShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case DRUM_COLLISION:
            if(getDamage(arb) > 2)
                [((__bridge DrumSprite*)b->data) explode];
            break;
        default:
            NSLog(@"POSTSOLVE COLLISION WITH KAMEA NOT MANAGED");
            break;
    }
}

static void DRUM_COLLISION_postSolve_with(cpShape *drumShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case DRUM_COLLISION:
            if(getDamage(arb) > 2) {
                [((__bridge DrumSprite*)b->data) explode];
                [((__bridge DrumSprite*)drumShape->data) explode];
            }
            break;
        case FIRE_BALL_COLLISION: {
            if(getDamage(arb) > 2)
                [((__bridge DrumSprite*)drumShape->data) explode];
            FireBallSprite *fireBall = (__bridge FireBallSprite *)b->data;
            [fireBall hasCollide];
            break;
        }
        case BOUNCING_BALL_COLLISION: {
            if(getDamage(arb) > 2)
                [((__bridge DrumSprite*)drumShape->data) explode];
            break;
        }
        case GRENADE_COLLISION: {
            if(getDamage(arb) > 2)
                [((__bridge DrumSprite*)drumShape->data) explode];
            [((__bridge GrenadeSprite *)b->data) fragment];
            break;
        }
        case GRENADE_FRAGMENT_COLLISION: {
            if(getDamage(arb) > 2)
                [((__bridge DrumSprite*)drumShape->data) explode];
            [((__bridge GrenadeFragmentSprite *)b->data) hasCollid];
            break;
        }
        default:
            NSLog(@"POSTSOLVE COLLISION WITH DRUM NOT MANAGED");
            break;
    }
}

static void collisionPostsolve(cpArbiter *arb, cpSpace *space, void *data) {
    
    CP_ARBITER_GET_SHAPES(arb, a, b);
    
    if (cpShapeGetCollisionType(a) != KAMEA_COLLISION && cpShapeGetCollisionType(b) != KAMEA_COLLISION) {
        if(!cpArbiterIsFirstContact(arb)) return;
    }
    
    switch (cpShapeGetCollisionType(a)) {
        case EXPLOSION_COLLISION:
            EXPLOSION_COLLISION_postSolve_with(a, b, arb);
            break;
        case ANVIL_COLLISION:
            ANVIL_COLLISION_postSolve_with(a, b, arb);
            break;
        case BLOCK_COLLISION:
            BLOCK_COLLISION_postSolve_with(a, b, arb);
            break;
        case TARGET_COLLISION:
            TARGET_COLLISION_postSolve_with(a, b, arb);
            break;
        case PLAYER_COLLISION:
            PLAYER_COLLISION_postSolve(a, b, arb);
            break;
        case END_POINT_COLLISION:
            END_POINT_COLLISION_postSolve_with(a, b, arb);
            break;
        case WALL_COLLISION:
            WALL_COLLISION_postSolve_with(a, b, arb);
            break;
        case TERRAIN_COLLISION:
            TERRAIN_COLLISION_postSolve_with(a, b, arb);
            break;
        case KAMEA_COLLISION:
            KAMEA_COLLISION_postSolve_with(a, b, arb);
            break;
        case DRUM_COLLISION:
            DRUM_COLLISION_postSolve_with(a, b, arb);
            break;
        default:
            NSLog(@"POSTSOLVE COLLISION WITH ALL NOT MANAGED");
            break;
    }
}
