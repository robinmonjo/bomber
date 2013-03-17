
#import "TimeLineLayer.h"
#import "TimeLine.h"
#import "ThumbLevelLayer.h"

/*
 WHEN UPDATE: In cocos2d in CCMenu change the registerWithDispatcher method so CCMenu doesn't swallow touches !!!
 ISSUE: when touching a CCMenu, the touched is swallowed that makes impossible to scroll the layer.
 SOLUTION: modify cocos2d code so it doesn't swallow the touch + add a BOOL hasMoved to detect if the user
 wanted to swipe or press the menu.
*/

/*
 Thumbnails = 65x45
 Layout:
 
 --------------------------------
 7px top margin
 45px thumbnail
 3px margin
 15px text
 10px margin
 --------------------------------
*/

@interface TimeLineLayer()

#define SINGLE_SPACE_WIDTH 65
#define MARGIN 25

- (CGPoint) computePosition;

@end

@implementation TimeLineLayer

static TimeLineLayer *instance;

+ (TimeLineLayer*) sharedInstance {
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [self node];
        }
    }
    return instance;
}

//Constructor
- (id) init {
    
    if(self=[super init]) {
        
        NSInteger nbLevels = [TimeLine instance].levels.count;
        CGFloat width = nbLevels * SINGLE_SPACE_WIDTH + (nbLevels - 1) * MARGIN;
        [self setContentSize:CGSizeMake(width, TIME_LINE_LAYER_HEIGHT)];
        
        hasMoved = NO;
        self.isTouchEnabled = YES;
        
        [self refresh];
    }
    return self;
}

- (void) refresh {
    NSInteger i = 0;//loop indice
    
    for (Level *level in [TimeLine instance].levels) {
        
        ThumbLevelLayer *layer = [ThumbLevelLayer initWithLevel:level width:SINGLE_SPACE_WIDTH height:TIME_LINE_LAYER_HEIGHT];
        
        //Setting position
        CGFloat x = i*(SINGLE_SPACE_WIDTH + MARGIN);
        layer.position = CGPointMake(x, 0);
        
        [self addChild:layer];
        
        ++i;
    }
    self.position = [self computePosition];
}

- (CGPoint) computePosition {
    int ind = [[TimeLine instance].levels indexOfObject:CURRENT_LEVEL];
    return CGPointMake(SCREEN_WIDTH/2-(ind*(SINGLE_SPACE_WIDTH+MARGIN))-SINGLE_SPACE_WIDTH/2, SCREEN_HEIGHT);
}

//Replace the layer with current level at the center of the screen
- (void) backToInitialPosition {
	[self runAction:[CCEaseBackIn actionWithAction:[CCMoveTo actionWithDuration:0.25 position:[self computePosition]]]];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint p = [self convertTouchToNodeSpace:touch];
    
    //If the touch is not inside the layer, ignore it and don't claim it
    if(!CGRectContainsPoint(LAYER_RECT, p)) return NO;
    
    //Else
    startSwipe = p.x;
    //Cancel any previous selector
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(backToInitialPosition) object:self];
    //Claim the touch
    return YES;
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint p = [self convertTouchToNodeSpace:touch];
    
    hasMoved = YES;//We are swipping, not pressing a button

    //Calculate new position and move layer
    CGFloat newX = self.position.x + (p.x - startSwipe);
    self.position = CGPointMake(newX, self.position.y);
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    hasMoved = NO; //Reset the indicator
    
    //In 3 seconds, if no inputs, go back to initial position
    [self performSelector:@selector(backToInitialPosition) withObject:self afterDelay:3];
    
    //If the last point went to far, replace the layer
    CGFloat newX;
    if (self.position.x > SCREEN_WIDTH / 2)
        newX = SCREEN_WIDTH/2 - SINGLE_SPACE_WIDTH/2;
    else if(self.position.x + self.contentSize.width < SCREEN_WIDTH / 2)
        newX = SCREEN_WIDTH/2 - self.contentSize.width + SINGLE_SPACE_WIDTH/2;
    else 
        return;
    
    //Animate the replacement
    CGPoint newPosition = CGPointMake(newX, self.position.y);
    CCAction *impulsion = [CCEaseBackIn actionWithAction:[CCMoveTo actionWithDuration:0.25 position:newPosition]];
	[self runAction:impulsion];

}

-(void) registerWithTouchDispatcher {
	[[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


@end
