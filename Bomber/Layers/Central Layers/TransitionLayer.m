

#import "TransitionLayer.h"

@implementation TransitionLayer

+(CCScene *) sceneWithLevel:(Level *)l {
	CCScene *scene = [CCScene node];
	TransitionLayer *layer = [[TransitionLayer alloc] initWithLevel:l];
	[scene addChild: layer];
	return scene;
}

- (id) initWithLevel:(Level *)l {
    NSAssert( [l isKindOfClass:[TransitionLevel class]] , @"TransitionLayer must be initialized with a GameLevel instance");
    return [super initWithLevel:l];
} 

@end
