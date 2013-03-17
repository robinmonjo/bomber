
#import "BomberSprite.h"
#import "chipmunk.h"
#import "PathNode.h"
#import "BombSprite.h"
#import "TargetSprite.h"
#import "BlockSprite.h"
#import "EndPointSprite.h"
#import "WeaponsLayer.h"
#import "DrumSprite.h"
#import "LevelLayer.h"
#import "LineSmoother.h"
#import "BreakableBlockSprite.h"
#import "KameaSprite.h"
#import "TerrainSprite.h"
#import "StarSprite.h"
#import "PhysicParticles.h"
#import "PhysicManager.h"
#import "FireBallSprite.h"
#import "BlackHoleSprite.h"
#import "BouncingBallSprite.h"
#import "BlockAtomiserSprite.h"
#import "GrenadeSprite.h"
#import "GrenadeFragmentSprite.h"

@interface GameLayer : LevelLayer {
@private
    
    PhysicManager *physicManager;
    
    BomberSprite *bomber;
    EndPointSprite *endPoint;
    PathNode *pathNode;
    BOOL gameRunning;
    int lastSmoothedIndex;
    int cpt;
    int nbStarCaught;
    
    CCSpriteBatchNode *_batchNode;
    
    NSInteger _maxPossiblePointsForThisLevel;

}

@property (nonatomic, retain) CCSpriteBatchNode *batchNode;
@property (nonatomic, assign) BOOL gameRunning;

- (void) addDrumSpriteAtPosition:(CGPoint) position;
- (void) addBlockSprite:(BlockSprite*) block position:(CGPoint) position;
- (void) addTargetSpriteAtPosition:(CGPoint) position;
- (void) addEndPointAtPosition:(CGPoint) position tag:(int) tag;
- (void) addTerrainSpriteWithRect:(CGRect) rect atPosition:(CGPoint) position;
- (void) addStarSpriteAtPosition:(CGPoint) position;

- (void) starCaught;

@end
