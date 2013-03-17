
#import "Collector.h"
#import "ParticlesManager.h"
#import "chipmunk.h"

@protocol SpaceInsertionSuppression <NSObject>

- (void) hasBeenRemovedFromSpace:(cpSpace *) space;
- (void) hasBeenAddedToSpace:(cpSpace *) space managedByLayer:(CCLayer *) layer;

@end

@interface PhysicSprite : CCSprite <SpaceInsertionSuppression> {
@protected
    cpBody *_body;
    cpShape *_shape;
    NSInteger _pointEarnedWhenDestroyed;
}

@property (nonatomic, assign) cpBody *body;
@property (nonatomic, assign) cpShape *shape;
@property (nonatomic, assign) NSInteger pointEarnedWhenDestroyed;

- (void) setBloodSplashAtPoint:(CGPoint) p withNormal:(cpVect) n;
- (void) setSmokeAtPoint:(CGPoint) p withNormal:(cpVect) n;
- (void) suckedByBlackHoleWithCenter:(CGPoint)blackHoleCenter;

- (void) showPointEarned;

@end
