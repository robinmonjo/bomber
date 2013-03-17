//
//  FragmentGrenadeSprite.h
//  Bomber
//
//  Created by Robin Monjo on 10/3/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "LaunchableWeaponSprite.h"

@interface GrenadeSprite : LaunchableWeaponSprite {
@private
    NSMutableArray *_preparedFragments;
    BOOL hasFragmented;
}

@property (nonatomic, retain) NSMutableArray *preparedFragments;

+ (GrenadeSprite *) init;

- (void) fragment;

@end
