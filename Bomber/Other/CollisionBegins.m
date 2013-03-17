
#import "GameLayer.h"

static float getForceMultiplier(cpShape *shape) {
    return -600*shape->body->m;
}

static void applyImpulse(cpArbiter *arb, cpShape *shape) {
    int i = cpArbiterGetCount(arb);
    cpVect n = cpArbiterGetNormal(arb, i-1);
    cpVect point = cpArbiterGetPoint(arb, i-1);
    cpVect offset = cpvsub(point, shape->body->p);
    cpBodyApplyImpulse(shape->body, cpvmult(n, getForceMultiplier(shape)), offset);
}

static void setBloodSplash(cpArbiter *arb, PhysicSprite *sprite) {
    /*
     The normal of an impact changes according to the order of the collision type:
     if CP_ARBITER_GET_SHAPES(arb, a, b) gives 'a' is the sprite overlapping (e.g: explosion)
     do : cpBodyWorld2Local(block.body, cpvadd(p, cpvmult(n, d/2))
     else do : cpBodyWorld2Local(block.body, cpvsub(p, cpvmult(n, d/2))
     */
    
    int i = cpArbiterGetCount(arb);
    cpVect n = cpArbiterGetNormal(arb, i-1);
    cpVect p = cpArbiterGetPoint(arb, i-1);
    cpFloat d = cpArbiterGetDepth(arb, i-1);
    
    cpVect point = cpBodyWorld2Local(sprite.body, cpvsub(p, cpvmult(n, d/2)));
    [sprite setBloodSplashAtPoint:point withNormal:n];
}

static void setSmoke(cpArbiter *arb, PhysicSprite *sprite) {
    int i = cpArbiterGetCount(arb);
    cpVect n = cpArbiterGetNormal(arb, i-1);
    cpVect p = cpArbiterGetPoint(arb, i-1);
    cpFloat d = cpArbiterGetDepth(arb, i-1);
    
    cpVect point = cpBodyWorld2Local(sprite.body, cpvsub(p, cpvmult(n, d/2)));
    [sprite setSmokeAtPoint:point withNormal:n];
}

static void suckedByBlackHole(PhysicSprite *sprite, CGPoint blacHoleCenter) {
    [sprite suckedByBlackHoleWithCenter:blacHoleCenter];
}

static int EXPLOSION_COLLISION_begins_with(cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case PLAYER_COLLISION: {
            BomberSprite *bomber = (__bridge BomberSprite *)(b->data);
            [bomber hasCollide];
            return cpTrue;
            break;
        }
        case BOUNCING_BALL_COLLISION:
            return cpFalse;
            break;
        default:
            NSLog(@"BEGIN COLLISION WITH EXPLOSION NOT MANAGED");
            return cpTrue;
            break;
    }
}
            

static int ANVIL_COLLISION_begins_with(cpShape *anvilShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case PLAYER_COLLISION: {
            BomberSprite *bomber = (__bridge BomberSprite *)(b->data);
            [bomber hasCollide];
            return cpTrue;
            break;
        }
        case BLOOD_SENSOR:
            setBloodSplash(arb, (__bridge PhysicSprite*)anvilShape->data);
            return cpFalse;
            break;
        case FIRE_SENSOR: {
            setSmoke(arb, (__bridge PhysicSprite*)anvilShape->data);
            return cpFalse;
            break;
        }
        case BLACK_HOLE_SENSOR: {
            suckedByBlackHole((__bridge PhysicSprite*)anvilShape->data, b->body->p);
            return cpFalse;
            break;
        }
        case BLOCK_ATOMIZER_SENSOR: {
            BlockAtomiserSprite *blockAtomiser = (__bridge BlockAtomiserSprite *)b->data;
            [blockAtomiser didNotHitBlock];
            return cpFalse;
            break;
        }
        case GRENADE_FRAGMENT_COLLISION: {
            [((__bridge GrenadeFragmentSprite *)b->data) hasCollid];
            return cpTrue;
            break;
        }
        default:
            NSLog(@"BEGIN COLLISION WITH ANVIL NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int BLOCK_COLLISION_begins_with(cpShape *blockShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case PLAYER_COLLISION: {
            BomberSprite *bomber = (__bridge BomberSprite *)(b->data);
            [bomber hasCollide];
            return cpTrue;
            break;
        }
        case BLOOD_SENSOR:
            setBloodSplash(arb, (__bridge PhysicSprite*)blockShape->data);
            return cpFalse;
            break;
        case FIRE_SENSOR:
            setSmoke(arb, (__bridge PhysicSprite*)blockShape->data);
            return cpFalse;
            break;
        case BLACK_HOLE_SENSOR: {
            suckedByBlackHole((__bridge PhysicSprite*)blockShape->data, b->body->p);
            return cpFalse;
            break;
        }
        case BLOCK_ATOMIZER_SENSOR: {
            [((__bridge BlockAtomiserSprite *)b->data) hitBlock:((__bridge BlockSprite *)blockShape->data)];
            return cpFalse;
            break;
        }
        default:
            NSLog(@"BEGIN COLLISION WITH BLOCK NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int TARGET_COLLISION_begins_with(cpShape *targetShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case PLAYER_COLLISION: {
            BomberSprite *bomber = (__bridge BomberSprite *)(b->data);
            [bomber hasCollide];
            return cpTrue;
            break;
        }
        case BLOOD_SENSOR:
            setBloodSplash(arb, (__bridge PhysicSprite*)targetShape->data);
            return cpFalse;
            break;
        case FIRE_SENSOR:
            setSmoke(arb, (__bridge PhysicSprite*)targetShape->data);
            return cpFalse;
            break;
        case BLACK_HOLE_SENSOR: {
            suckedByBlackHole((__bridge PhysicSprite*)targetShape->data, b->body->p);
            return cpFalse;
            break;
        }
        case BLOCK_ATOMIZER_SENSOR: {
            [((__bridge BlockAtomiserSprite *)b->data) didNotHitBlock];
            return cpFalse;
            break;
        }
        default:
            NSLog(@"BEGIN COLLISION WITH TARGET NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int PLAYER_COLLISION_begins_with(cpShape *playerShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case END_POINT_COLLISION: {
            [((__bridge BomberSprite *)(playerShape->data)) hasCollide];
            return cpTrue;
            break;
        }
        case WALL_COLLISION: {
            [((__bridge BomberSprite *)(playerShape->data)) hasCollide];
            return cpTrue;
            break;
        }
        case TERRAIN_COLLISION: {
            [((__bridge BomberSprite *)(playerShape->data)) hasCollide];
            return cpTrue;
            break;
        }
        case BLOOD_SENSOR: {
            BomberSprite *bomber = (__bridge BomberSprite*)playerShape->data;
            setBloodSplash(arb, bomber);
            return cpFalse;
            break;
        }
        case KAMEA_COLLISION:
            return cpFalse;
            break;
        case FIRE_BALL_COLLISION:
            return cpFalse;
            break;
        case FIRE_SENSOR:
            setSmoke(arb, (__bridge PhysicSprite*)playerShape->data);
            return cpFalse;
            break;
        case STAR_SENSOR:
            [((__bridge StarSprite*)b->data) hasBeenTaken];
            return cpFalse;
            break;
        case BOUNCING_BALL_COLLISION: {
            //[((__bridge BomberSprite *)(playerShape->data)) hasCollide];
            return cpFalse;
            break;
        }
        case GRENADE_FRAGMENT_COLLISION: {
            [((__bridge BomberSprite *)(playerShape->data)) hasCollide];
            [((__bridge GrenadeFragmentSprite *)b->data) hasCollid];
            return cpTrue;
            break;
        }
        default:
            NSLog(@"BEGIN COLLISION WITH PLAYER NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int TERRAIN_COLLISION_begins_with(cpShape *terrainShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BLOOD_SENSOR:
            setBloodSplash(arb, (__bridge PhysicSprite*)terrainShape->data);
            return cpFalse;
            break;
        case FIRE_SENSOR:
            setSmoke(arb, (__bridge PhysicSprite*)terrainShape->data);
            return cpFalse;
            break;
        case BLOCK_ATOMIZER_SENSOR: {
            [((__bridge BlockAtomiserSprite *)b->data) didNotHitBlock];
            return cpFalse;
            break;
        }
        case GRENADE_FRAGMENT_COLLISION: {
            [((__bridge GrenadeFragmentSprite *)b->data) hasCollid];
            return cpFalse;
            break;
        }
        default:
            NSLog(@"BEGIN COLLISION WITH TERRAIN NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int DRUM_COLLISION_begins_with(cpShape *drumShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BLACK_HOLE_SENSOR: {
            suckedByBlackHole((__bridge PhysicSprite*)drumShape->data, b->body->p);
            return cpFalse;
            break;
        }
        case BLOCK_ATOMIZER_SENSOR: {
            [((__bridge BlockAtomiserSprite *)b->data) didNotHitBlock];
            return cpFalse;
            break;
        }
        default:
            NSLog(@"BEGIN COLLISION WITH DRUM NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int FIRE_SENSOR_begins_with(cpShape *fireShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BOUNCING_BALL_COLLISION: {
            setSmoke(arb, (__bridge PhysicSprite*)b->data);
            return cpFalse;
            break;
        }
        default:
            NSLog(@"BEGIN COLLISION WITH FIRE NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int WALL_COLLISION_begins_with(cpShape *wallShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BLOCK_ATOMIZER_SENSOR: {
            [((__bridge BlockAtomiserSprite *)b->data) didNotHitBlock];
            return cpFalse;
            break;
        }
        case GRENADE_FRAGMENT_COLLISION: {
            [((__bridge GrenadeFragmentSprite *)b->data) hasCollid];
            return cpFalse;
            break;
        }
        default:
            NSLog(@"BEGIN COLLISION WITH WALL NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int END_POINT_COLLISION_begins_with(cpShape *endPointShape, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case BLOCK_ATOMIZER_SENSOR: {
            [((__bridge BlockAtomiserSprite *)b->data) didNotHitBlock];
            return cpFalse;
            break;
        }
        case GRENADE_FRAGMENT_COLLISION: {
            [((__bridge GrenadeFragmentSprite *)b->data) hasCollid];
            return cpFalse;
            break;
        }
        default:
            NSLog(@"BEGIN COLLISION WITH END_POINT NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int GRENADE_FRAGMENT_COLLISION_begins_with(cpShape *grenadeFragment, cpShape *b, cpArbiter *arb) {
    switch (cpShapeGetCollisionType(b)) {
        case GRENADE_FRAGMENT_COLLISION: {
            return cpFalse;
            break;
        }
        default:
            NSLog(@"BEGIN COLLISION WITH END_POINT NOT MANAGED");
            return cpTrue;
            break;
    }
}

static int collisionBegins(cpArbiter *arb, cpSpace *space, void *data) {
    
    CP_ARBITER_GET_SHAPES(arb, a, b);
    
    if(!cpArbiterIsFirstContact(arb)) return cpTrue;
    
    switch (cpShapeGetCollisionType(a)) {
        case EXPLOSION_COLLISION:
            return EXPLOSION_COLLISION_begins_with(b, arb);
            break;
        case ANVIL_COLLISION:
            return ANVIL_COLLISION_begins_with(a, b, arb);
            break;
        case BLOCK_COLLISION:
            return BLOCK_COLLISION_begins_with(a, b, arb);
            break;
        case TARGET_COLLISION:
            return TARGET_COLLISION_begins_with(a, b, arb);
            break;
        case PLAYER_COLLISION:
            return PLAYER_COLLISION_begins_with(a, b, arb);
            break;
        case TERRAIN_COLLISION:
            return TERRAIN_COLLISION_begins_with(a, b, arb);
            break;
        case DRUM_COLLISION:
            return DRUM_COLLISION_begins_with(a, b, arb);
            break;
        case FIRE_SENSOR:
            return FIRE_SENSOR_begins_with(a, b, arb);
            break;
        case WALL_COLLISION:
            return WALL_COLLISION_begins_with(a, b, arb);
            break;
        case END_POINT_COLLISION:
            return END_POINT_COLLISION_begins_with(a, b, arb);
            break;
        case GRENADE_FRAGMENT_COLLISION:
            return GRENADE_FRAGMENT_COLLISION_begins_with(a, b, arb);
            break;
        default:
            NSLog(@"collision begin NOT MANAGED");
            return cpTrue;
            break;
    }
}