//
//  ThumbLevelLayer.h
//  Bomber
//
//  Created by Robin Monjo on 9/17/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "Level.h"

#define NB_MAX_STARS 3

@interface ThumbLevelLayer : CCLayer {
@private
    Level *_level;
    CCSprite *_stars[NB_MAX_STARS];
    CCMenuItemFont *_lockSprite;
}

@property (nonatomic, retain) Level *level;

+ (ThumbLevelLayer *) initWithLevel:(Level *)level width:(CGFloat)w height:(CGFloat)h;

- (void) updateStarsAnimated:(BOOL) animated;
- (void) showLevelPassedAnimated:(BOOL) animated;
- (void) showUnlock;
    
@end
