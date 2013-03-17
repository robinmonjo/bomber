//
//  BouncingBallSprite.h
//  Bomber
//
//  Created by Robin Monjo on 9/22/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "LaunchableWeaponSprite.h"

@interface BouncingBallSprite : LaunchableWeaponSprite {
@private
    NSInteger _nbBounces;
}

+ (BouncingBallSprite *) init;

- (void) hasBounced;

@end
