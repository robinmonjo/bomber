//
//  PhysicManager.h
//  Bomber
//
//  Created by Robin Monjo on 9/12/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "chipmunk.h"
#import "Collector.h"

@interface PhysicManager : NSObject {
@private
    cpSpace * _space;
    cpShape * _walls[4];
    Collector *collector;
    
}

@property (nonatomic, assign) cpSpace *space;

- (void) initSpace;
- (void) updateAllShapes;
- (void) takeStep:(CGFloat)dt inLayer:(CCLayer *) layer;
- (void) addPhysicSprite:(PhysicSprite *) sprite;
- (void) clearSpace;

@end
