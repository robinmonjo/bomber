//
//  ExplosifPatchSprite.h
//  Bomber
//
//  Created by Robin Monjo on 10/3/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "LaunchableWeaponSprite.h"
#import "BlockSprite.h"

@interface BlockAtomiserSprite : LaunchableWeaponSprite

+ (BlockAtomiserSprite *) init;

- (void) hitBlock:(BlockSprite *) block;

- (void) didNotHitBlock;

@end
