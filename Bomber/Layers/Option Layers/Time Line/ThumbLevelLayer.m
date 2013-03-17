//
//  ThumbLevelLayer.m
//  Bomber
//
//  Created by Robin Monjo on 9/17/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "ThumbLevelLayer.h"
#import "TimeLine.h"

@implementation ThumbLevelLayer

@synthesize level=_level;

+ (ThumbLevelLayer *) initWithLevel:(Level *)level width:(CGFloat)w height:(CGFloat)h {
    ThumbLevelLayer *layer = [[self alloc] init];
    [layer setContentSize:CGSizeMake(w, h)];
    [layer setLevel:level];
    if ([level isKindOfClass:[GameLevel class]]) {
        ((GameLevel *)level).thumbView = layer;
    }
    return layer;
}

- (void) clicked {
    if([[TimeLine instance] isLevelAccessible:self.level]) {
        [[TimeLine instance] goToLevel:self.level];
    }
}

- (void) setLevel:(Level *)level {
    _level = level;
    
    //Create the thumbnail
    CCMenuItem *menuItem = [CCMenuItemImage itemWithNormalImage:level.thumbBgFile
                                           selectedImage:level.thumbBgFile
                                                  target:self
                                                selector:@selector(clicked)];
    
    CCMenu *menu = [CCMenu menuWithItems:menuItem, nil]; //so its clickable
    menu.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2 + 12);
    
    [self addChild:menu];
    
    if(![[TimeLine instance] isLevelAccessible:level]) {
        _lockSprite = [CCMenuItemFont itemWithString:@"X"];
        [_lockSprite setFontSize:15];
        _lockSprite.position = CGPointMake(menuItem.contentSize.width/2, menuItem.contentSize.height/2);
        [menuItem addChild:_lockSprite];
    }
    
    //Adding stars
    if ([level isKindOfClass:[GameLevel class]]) {
        [self updateStarsAnimated:NO];
        if (((GameLevel *)level).passed) {
            [self showLevelPassedAnimated:NO];
        }
    }
    
    //Creating text
    CCMenuItemFont *text = [CCMenuItemFont itemWithString:level.label];
    [text setFontSize:11];
    [text setFontName:@"Helvetica"];
    [text setColor:ccc3(0, 0, 0)];
    text.position = CGPointMake(self.contentSize.width/2, 18);
    [self addChild:text];
    
    //check if current level
    if (CURRENT_LEVEL == level) {
        //set arrow
        CCSprite *arrow = [CCSprite spriteWithFile:@"black_arrow.png"];
        arrow.position = CGPointMake(self.contentSize.width/2, 0);
        [self addChild:arrow];
    }
    
}

//called only on game level
- (void) updateStarsAnimated:(BOOL) animated {
    
    for (int i = 0; i < NB_MAX_STARS; ++i) {
        
        [_stars[i] removeFromParentAndCleanup:YES];
        
        CCSprite *star;
        CCAction *action;
        if(i < ((GameLevel*)self.level).nbStars) {
            star = [CCSprite spriteWithFile:@"star.png"];
            //animate a earned star
            if (animated) {
                star.scale = 2;
                action = [CCEaseBounceInOut actionWithAction:[CCScaleTo actionWithDuration:1 scale:0.8]];
            }
            else {
                star.scale = 0.8;
            }
        }
        else {
            star = [CCSprite spriteWithFile:@"grey_star.png"];
            star.scale = 0.8;
        }
        star.position = CGPointMake(17+0.8*star.contentSize.width*i, 33);
        [self addChild:star z:10];
        
        if (action && animated) {
            [star runAction:action];
        }
        
        _stars[i] = star;
    }
}

- (void) showLevelPassedAnimated:(BOOL) animated {
    
    if (((GameLevel *)self.level).passed) {
        CCMenuItemFont *item = [CCMenuItemFont itemWithString:@"GG"];
        [item setFontSize:11];
        item.color = ccc3(0, 255, 34);
        item.position = CGPointMake(self.contentSize.width, 60);
        [self addChild:item];
        
        if (animated) {
            item.scale = 2;
            CCAction *action = [CCEaseBounceInOut actionWithAction:[CCScaleTo actionWithDuration:1 scale:0.8]];
            [item runAction:action];
        }
        
    }
}

- (void) showUnlock {
    //TODO: animate an unlocked sprite
    [_lockSprite removeFromParentAndCleanup:YES];
}

@end
