//
//  FireBallSprite.h
//  Bomber
//
//  Created by Robin Monjo on 9/20/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "LaunchableWeaponSprite.h"

@interface FireBallSprite : LaunchableWeaponSprite {
@private
    BOOL _willBeRemoved;
}

+(FireBallSprite *) init;

- (void) hasCollide;

@end
