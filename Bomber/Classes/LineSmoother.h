

@interface LineSmoother : NSObject <CCStandardTouchDelegate>

+ (LineSmoother*) instance;

- (NSMutableArray*) smoothLine:(NSMutableArray*) points;
- (NSArray *)douglasPeucker:(NSArray *)points epsilon:(float)epsilon;
- (float)perpendicularDistance:(CGPoint)point lineA:(CGPoint)lineA lineB:(CGPoint)lineB;
- (NSMutableArray *)catmullRomSpline:(NSArray *)points segments:(int)segments;
@end
