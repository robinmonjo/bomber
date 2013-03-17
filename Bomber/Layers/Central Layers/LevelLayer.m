
#import "LevelLayer.h"

/*
 Private interface
*/

@interface LevelLayer()

- (void) setLevelLabelsPosition;

@end


/*
 Implementation
*/
@implementation LevelLayer

static NSInteger state = CENTERED;

+ (NSInteger) state {
    return state;
}

+ (void) setState:(NSInteger)newState {
    state = newState;
}


//Constructor
- (id) initWithLevel:(Level *) l {
    
    if(self = [super init]) {
        level = l;
    }
    return self;
}

- (void) onEnter {
    [super onEnter];
    
    [self setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [self addChild:[TimeLineLayer node]];
    
    
    nextLevelLabel = [CCMenuItemFont itemWithString:@"Next"];
    [nextLevelLabel setFontSize:15];
    [nextLevelLabel setFontName:@"Helvetica"];
    [nextLevelLabel setColor:ccc3(0, 0, 0)];
    
    previousLevelLabel = [CCMenuItemFont itemWithString:@"Back"];
    [previousLevelLabel setFontSize:15];
    [previousLevelLabel setFontName:@"Helvetica"];
    [previousLevelLabel setColor:ccc3(0, 0, 0)];
    
    [self addChild:nextLevelLabel];
    [self addChild:previousLevelLabel];
    [self setLevelLabelsPosition];
    
    CCSprite *globalBg = [CCSprite spriteWithFile:@"global_bg.jpg"];
    globalBg.position = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT/2)+10);
    [self addChild:globalBg z:-10];
    
    
    CCSprite *bg = [CCSprite spriteWithFile:CURRENT_LEVEL.bgFile];
    [bg setPosition:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    [self addChild:bg z:0];
    
    self.isTouchEnabled = YES;
    
    move = UNDEFINED_MOVEMENT;
    
    if(state == CENTERED)  {
        [self setPosition:CGPointZero];
    }
    else if(state == DOWN)
        [self setPosition:CGPointMake(0, -TIME_LINE_LAYER_HEIGHT)];
    else if(state == UP)
        [self setPosition:CGPointMake(0, WEAPONS_LAYER_HEIGHT)];

}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint p = [self convertTouchToNodeSpace:touch];
    
    //If the touch is not inside the layer, ignore it and don't claim it
    if (!CGRectContainsPoint(LAYER_RECT, p)) return NO;
    
     NSLog(@"%f, %f", p.x, p.y);
    
    startPoint = p;
        
    return YES;
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint p = [self convertTouchToNodeSpace:touch];
    
    if (move == UNDEFINED_MOVEMENT) {
        if(abs(p.x - startPoint.x) >= abs(p.y - startPoint.y))
           move = HORIZONTAL_MOVEMENT;
        else
           move = VERTICAL_MOVEMENT;
    }
    
    BOOL hasMoved = YES;
    if(move == HORIZONTAL_MOVEMENT) {
        float x = self.position.x + (p.x - startPoint.x);
        if(x < -SIDE_LAYER_WIDTH) {
            x = -SIDE_LAYER_WIDTH;
            hasMoved = NO;
        }
        else if(x > SIDE_LAYER_WIDTH) {
            x = SIDE_LAYER_WIDTH;
            hasMoved = NO;
        }
        self.position = CGPointMake(x, self.position.y);
        [nextLevelLabel setOpacity:255*(x/-SIDE_LAYER_WIDTH)];
        [previousLevelLabel setOpacity:255*(x/SIDE_LAYER_WIDTH)];
        if (!hasMoved)
            startPoint = p;
        return;
    }
    else {
        int y = self.position.y + (p.y - startPoint.y);
        if(y < -TIME_LINE_LAYER_HEIGHT){
            y = -TIME_LINE_LAYER_HEIGHT;
            hasMoved = NO;
        }
        else if(y > WEAPONS_LAYER_HEIGHT){
            y = WEAPONS_LAYER_HEIGHT;
            hasMoved = NO;
        }

        self.position = CGPointMake(0, y);
        if(!hasMoved)
            startPoint = p;
    }
    
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
        
    if (move == HORIZONTAL_MOVEMENT) {
        BOOL changeLayer = TRUE;
        if(self.position.x <= -SIDE_LAYER_WIDTH)
            changeLayer = [[TimeLine instance] nextLevel];
        else if(self.position.x >= SIDE_LAYER_WIDTH)
            changeLayer = [[TimeLine instance] previousLevel];
        else
            changeLayer = NO;
        
        if (!changeLayer)
            [self runAction:[CCMoveTo actionWithDuration:0.1 position:CGPointMake(0, self.position.y)]];
        
    }
    else {
        int y;
        if(self.position.y >= WEAPONS_LAYER_HEIGHT/2) {
            y = WEAPONS_LAYER_HEIGHT;
            state = UP;
        }
        else if(self.position.y <= -TIME_LINE_LAYER_HEIGHT/2) {
            y = -TIME_LINE_LAYER_HEIGHT;
            state = DOWN;
        }
        else {
            y = 0;
            state = CENTERED;
        }
        [self runAction:[CCMoveTo actionWithDuration:0.1 position:CGPointMake(0, y)]];
        [self setLevelLabelsPosition];
    }
        
    move = UNDEFINED_MOVEMENT;
        
}

- (void) setLevelLabelsPosition {
    int y;
    if (state == CENTERED)
        y = SCREEN_HEIGHT/2;
    else if(state == UP)
        y = SCREEN_HEIGHT/2 - WEAPONS_LAYER_HEIGHT;
    else
        y = SCREEN_HEIGHT/2 + TIME_LINE_LAYER_HEIGHT;
    
    previousLevelLabel.position = CGPointMake(-SIDE_LAYER_WIDTH/2, y);
    nextLevelLabel.position = CGPointMake(SCREEN_WIDTH + SIDE_LAYER_WIDTH/2, y);
    
}

-(void) registerWithTouchDispatcher {
	[[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:YES];
}




@end
