#import "TimeLine.h"
#import "TimeLineLayer.h"
#import "WeaponsLayer.h"
#import "Level.h"

#define SIDE_LAYER_WIDTH 80

typedef enum _movement {
    VERTICAL_MOVEMENT,
    HORIZONTAL_MOVEMENT,
    UNDEFINED_MOVEMENT
} Movement;

@interface LevelLayer : CCLayer <CCTargetedTouchDelegate> {
@protected
    //State of the layer
    #define DOWN -1
    #define CENTERED 0
    #define UP 1
    
    Level *level;
    
@private
    CGPoint startPoint;
    Movement move;
    
    CCMenuItemFont *nextLevelLabel;
    CCMenuItemFont *previousLevelLabel;
}

+ (NSInteger) state;
+ (void) setState:(NSInteger)newState;

+ (CCScene*) sceneWithLevel:(Level *) l;
- (id) initWithLevel:(Level *) l;

@end
