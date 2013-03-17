
#import "GameLayer.h"
#import "TimeLine.h"

@interface WorldBuilder : NSObject

+ (WorldBuilder *)instance;

-(void) buildWorldNumber:(int) n layer:(GameLayer *) layer;

@end
