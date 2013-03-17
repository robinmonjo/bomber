//
//  EndLevelLayer.m
//  Bomber
//
//  Created by Robin Monjo on 9/14/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "EndLevelLayer.h"

@implementation EndLevelLayer

+ (EndLevelLayer *) init {
    EndLevelLayer *layer = [[EndLevelLayer alloc] initWithColor:ccc4(0, 0, 0, 125) width:200 height:100];
    return layer;
}

- (id) initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h {
    
    if(self = [super initWithColor:color width:w height:h]) {
        
    }
    return self;
}

- (void) setPositionRelativeToBomberPosition:(CGPoint) bomberPos {
    //width and height must be smaller than SCREEN_WIDTH/2 and SCREEN_HEIGHT/2 (and the margin)
    CGFloat x, y;
    if (bomberPos.x + self.contentSize.width < SCREEN_WIDTH - 10) {
        x = bomberPos.x;
    }
    else {
        x = bomberPos.x - self.contentSize.width;
    }
    
    if (bomberPos.y + self.contentSize.height < SCREEN_HEIGHT - 10) {
        y = bomberPos.y;
    }
    else {
        y = bomberPos.y - self.contentSize.height;
    }
    
    self.position = CGPointMake(x, y);
}

- (void) onEnter {
    [super onEnter];

    self.scale = .1f;
    CCAction *action = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:1 scale:1]];
    [self runAction:action];
}

@end
