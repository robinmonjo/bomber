
#import "TransitionLevel.h"
#import "TransitionLayer.h"

@implementation TransitionLevel


- (id) initWithBgFile:(NSString *)bg {
 
    if (self = [super initWithBgFile:bg]) {
        label = @"Transition";
    }
    return self;
}


- (CCScene *) scene {
    return [TransitionLayer sceneWithLevel:self];
}

@end
