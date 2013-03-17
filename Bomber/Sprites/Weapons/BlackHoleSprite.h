//
//  BlackHoleSprite.h
//  Bomber
//
//  Created by Robin Monjo on 9/21/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "PhysicSprite.h"
#import "WeaponSpriteProtocol.h"

@interface BlackHoleSprite : PhysicSprite <WeaponSpriteProtocol> {
@private
    CGPoint _gravityPosition;
    CCParticleSystemQuad *_emitter;
    cpSpace *_space;
}

+(BlackHoleSprite *) init;


@end
