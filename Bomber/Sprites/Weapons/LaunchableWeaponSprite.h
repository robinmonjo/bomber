//
//  LaunchableWeaponSprite.h
//  Bomber
//
//  Created by Robin Monjo on 10/3/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "PhysicSprite.h"
#import "WeaponSpriteProtocol.h"

@interface LaunchableWeaponSprite : PhysicSprite <WeaponSpriteProtocol> {
@protected
    CGPoint _direction;
}

@property (nonatomic, assign) CGPoint direction;

- (void) launch;
void noGravityVelocityFunc(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt);

@end
