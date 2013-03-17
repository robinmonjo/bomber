
#import "PathNode.h"

@implementation PathNode

@synthesize drawPoints;

- (id) init {
    self = [super init];
    
    glLineWidth(3.0f);
    return self;
}

- (void) draw {

    if (drawPoints && [drawPoints count] < 2)
        return;
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    for (unsigned int i = 0; i < [drawPoints count]; i ++) {
        if(i + 1 < [drawPoints count]){
            CGPoint first = [[drawPoints objectAtIndex:i] CGPointValue];
            CGPoint second = [[drawPoints objectAtIndex:i + 1] CGPointValue];;
            ccDrawLine(first, second);
        }
    }
   /* for (unsigned int i = 0; i < [drawPoints count]; i ++) {
        CGPoint first = [[drawPoints objectAtIndex:i] CGPointValue];
        ccDrawCircle(first, 4, CC_DEGREES_TO_RADIANS(360), 100, NO);
    }*/
}


@end
