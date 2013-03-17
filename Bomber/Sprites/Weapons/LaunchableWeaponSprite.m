//
//  LaunchableWeaponSprite.m
//  Bomber
//
//  Created by Robin Monjo on 10/3/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "LaunchableWeaponSprite.h"

@implementation LaunchableWeaponSprite

@synthesize direction=_direction;

void noGravityVelocityFunc(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt) {
	cpBodyUpdateVelocity(body, cpvzero, damping, dt);
}

- (void) hasBeenAddedToSpace:(cpSpace *)space managedByLayer:(CCLayer *)layer {
    [super hasBeenAddedToSpace:space managedByLayer:layer];
    [self launch];
}

#warning Abstract class, unimplemented weapons
- (void) launch {}
- (NSString *) file {return nil;}
- (NSString *) label {return nil;}

@end
