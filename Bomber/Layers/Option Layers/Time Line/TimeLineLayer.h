
#define TIME_LINE_LAYER_HEIGHT 80

@interface TimeLineLayer : CCLayer <CCTargetedTouchDelegate> {
@private
    //Attributes to manage touches inputs
    NSInteger startSwipe;
    BOOL hasMoved;
}

+ (TimeLineLayer*) sharedInstance;


@end
