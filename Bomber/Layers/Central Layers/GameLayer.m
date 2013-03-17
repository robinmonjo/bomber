
#import "GameLayer.h"
#import "WorldBuilder.h"
#import "TimeLine.h"
#import "EndLevelLayer.h"

@interface GameLayer()

- (BOOL) levelPassed;
- (BOOL) gameEnded;

//if all bodies in the space have a kinetic energy less than this, it considered not mouving
#define KINETIC_ENERGY_TRESHOLD 70

@end

@implementation GameLayer

@synthesize batchNode=_batchNode;

+(CCScene *) sceneWithLevel:(Level *)l {
	CCScene *scene = [CCScene node];
	GameLayer *layer = [[GameLayer alloc] initWithLevel:l];
	[scene addChild: layer];
	return scene;
}

- (id) initWithLevel:(Level *) l {
    NSAssert( [l isKindOfClass:[GameLevel class]] , @"GameLayer must be initialized with a GameLevel instance");
    if(self = [super initWithLevel:l]) {
        lastSmoothedIndex = 0;
        cpt = 0;
        physicManager = [[PhysicManager alloc] init];
        _maxPossiblePointsForThisLevel = 0; //will be set according to physic sprite set by world builder
    }
    
    return self;
}

- (void) onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];
    
    [physicManager initSpace];
    
    
    [[WorldBuilder instance] buildWorldNumber:((GameLevel*)level).number layer:self];
    
    [self scheduleUpdate];
    
    pathNode = [PathNode node];
    pathNode.drawPoints = bomber.path;
    [self addChild:[[WeaponsLayer alloc] initWithWeapons:((GameLevel*)level).weapons] z:11];
    
    gameRunning = NO;
    
    [self addChild:pathNode z:1];
}

- (void) onExit {
    [physicManager clearSpace];
    //clear collector data
    [[Collector sharedInstance] clear];
    [Collector sharedInstance].pointEarned = 0;
}

//-----------------------------------------------------------------------------------
//Executed each frame
//-----------------------------------------------------------------------------------

-(void) update:(ccTime) delta {
    
    if(!gameRunning) return;
    
	int steps = 2;
	//CGFloat dt = delta/(CGFloat)steps;
    CGFloat dt = [[CCDirector sharedDirector] animationInterval]/(CGFloat)steps;
    
	for(int i=0; i<steps; i++){
		[physicManager takeStep:dt inLayer:self];
	}
    
    [physicManager updateAllShapes];
    
    if(bomber.hasStoppedMoving) {
        if([self gameEnded]) {
            
            [self unscheduleUpdate];
            
            gameRunning = NO;
            BOOL hasWon = [self levelPassed];
            
            if (hasWon) {
                [self levelSuceeded];
            }
            
            NSString *mess;
            if(hasWon)
                mess = @"Success";
            else
                mess = @"Fail";
            
            CCMenuItemFont *info = [CCMenuItemFont itemWithString:mess];
            [info setPosition:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
            [info setColor:ccc3(0, 0, 0)];
            [self addChild:info];
            [[TimeLine instance] save];
        }
    }    
}
                                        
- (void) levelSuceeded {
    
    //collector contains the score of destroyed object, weapons not used will bring score as well.
    
    if (!((GameLevel *)level).passed || ((GameLevel *)level).nbStars < nbStarCaught) {
        //visjual update in timelinelayer
        CCFiniteTimeAction *moveDown = [CCEaseExponentialOut actionWithAction:
                                        [CCMoveBy actionWithDuration:1 position:CGPointMake(0, - TIME_LINE_LAYER_HEIGHT)]];
        moveDown = [CCSequence actionOne:moveDown two:[CCCallFunc actionWithTarget:self selector:@selector(updateThumLevelLayer)]];
        [self runAction:moveDown];
        [LevelLayer setState:DOWN];
    }
    
    EndLevelLayer *layer = [EndLevelLayer init];
    [layer setPositionRelativeToBomberPosition:bomber.position];
    [self addChild:layer];
}

- (void) updateThumLevelLayer {
    if (!((GameLevel *)level).passed) {
        ((GameLevel *)level).passed = YES;
        //[[[TimeLine instance] getGameLevelAfterLevel:level] setLocked:NO];
    }
    
    if (((GameLevel *)level).nbStars < nbStarCaught) {
        ((GameLevel *)level).nbStars = nbStarCaught;
    }
}
                                        
//-----------------------------------------------------------------------------------
//Logic methods
//-----------------------------------------------------------------------------------

- (BOOL) levelPassed {
    BOOL hasWon = true;
    for (CCNode *node in [self children]) {
        if([node isKindOfClass:[TargetSprite class]]) {
            [((TargetSprite *)node) moquePlayer];
            hasWon = NO;
        }
    }
    if(!hasWon) return NO;

    CGRect validArea = endPoint.boundingBox;
    validArea.size.height += bomber.boundingBox.size.height; 
    hasWon = CGRectContainsPoint(validArea, bomber.position);
    return hasWon;
}

- (BOOL) gameEnded {
    for (CCNode *node in [self children]) {
        if([node isKindOfClass:[PhysicSprite class]]) {
            PhysicSprite *sprite = (PhysicSprite*)node;
            if(sprite) {
                float energy = cpBodyKineticEnergy(sprite.body);
                if(energy > KINETIC_ENERGY_TRESHOLD)
                    return NO;
            }
        }
    }
    return YES;
}

- (void) starCaught {
    nbStarCaught++;
}

//------------------------------------------------------------------------------------
//Use to build world
//------------------------------------------------------------------------------------
- (void) addSprite:(PhysicSprite*) sprite atPosition:(CGPoint) position {
    [sprite setPosition:position];
    [self addChild:sprite];
    [physicManager addPhysicSprite:sprite];
    _maxPossiblePointsForThisLevel += sprite.pointEarnedWhenDestroyed;
}

- (void) addDrumSpriteAtPosition:(CGPoint) position {
    DrumSprite *drum = [DrumSprite init];
    [self addSprite:drum atPosition:position];
}

- (void) addBlockSprite:(BlockSprite*) block position:(CGPoint) position {
    [self addSprite:block atPosition:position];
}

- (void) addTerrainSpriteWithRect:(CGRect) rect atPosition:(CGPoint) position {
    TerrainSprite * terrain = [TerrainSprite initWithRect:rect];
    [self addSprite:terrain atPosition:position];
}

- (void) addTargetSpriteAtPosition:(CGPoint) position {
    TargetSprite *target = [TargetSprite init];
    [self addSprite:target atPosition:position];
}

- (void) addStarSpriteAtPosition:(CGPoint) position {
    StarSprite *star = [StarSprite init];
    [self addSprite:star atPosition:position];
}

- (void) addEndPointAtPosition:(CGPoint) position tag:(int) tag {
    EndPointSprite* p = [EndPointSprite init];
    [self addSprite:p atPosition:position];
    
    if(tag == START_POINT) { 
        bomber = [BomberSprite init];
        CGPoint bomberPos = CGPointMake(position.x, position.y+bomber.contentSize.height/2);
        [self addSprite:bomber atPosition:bomberPos];
    }
    else if(tag == END_POINT)
        endPoint = p;
}

//-----------------------------------------------------------------------------------
//Touch screen inputs
//-----------------------------------------------------------------------------------

- (void) realTimeLineSmooth {
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(lastSmoothedIndex, bomber.path.count-lastSmoothedIndex)];
    NSMutableArray *pointsToSmooth = [NSMutableArray arrayWithArray:[bomber.path objectsAtIndexes:indexes]];
    pointsToSmooth = [[LineSmoother instance] smoothLine:pointsToSmooth];
    [bomber.path removeObjectsAtIndexes:indexes];
    [bomber.path addObjectsFromArray:pointsToSmooth];
    lastSmoothedIndex = bomber.path.count;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint p = [self convertTouchToNodeSpace:touch];
        
    //Can start drawing path
    if (CGRectContainsPoint(bomber.boundingBox, p) && !gameRunning && [LevelLayer state] == CENTERED ) {
        gameRunning = YES;
    }
    
    //Drop a weapon
    else if(gameRunning && ((GameLevel*)level).weapons.count > 0) {
        CCSprite <WeaponSpriteProtocol>* weapon = [((GameLevel*)level).weapons objectAtIndex:0];
        
        if(bomber.isWaitingToLaunchAWeapon) {
            [bomber launchWeapon:[((GameLevel*)level).weapons objectAtIndex:0] inDirection:p];
            [((GameLevel*)level).weapons removeObjectAtIndex:0];
        }
        else {
            [bomber dropWeapon:weapon inLayer:self];
            if(![weapon isKindOfClass:[LaunchableWeaponSprite class]]) {
                    [((GameLevel*)level).weapons removeObjectAtIndex:0];
            }
        }
    }
    
    //Navigation gesture managed by superclass
    else if(!gameRunning || bomber.hasStoppedMoving) {
        return [super ccTouchBegan:touch withEvent:event];
    }
    
    //In any case, we claim the touch
    return YES;
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint p = [self convertTouchToNodeSpace:touch];
        
    //The player is drawing the path
    if(gameRunning && !bomber.isMoving && !bomber.hasStoppedMoving) {
        
        if(cpt == 40) {//smooth the points
            [self realTimeLineSmooth];
            cpt = 0;
        }
        cpt++;
        [bomber.path addObject:[NSValue valueWithCGPoint: p]];
    }
    
    //The player is navigating
    else if(!gameRunning || (bomber.hasStoppedMoving && ((GameLevel*)level).weapons.count == 0)) {
        [super ccTouchMoved:touch withEvent:event];
    }
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //The player just finished drawing the path
    if(gameRunning && !bomber.hasStoppedMoving && !bomber.isMoving) {
        
        [self realTimeLineSmooth];
        [bomber moveToLocation];
    }
    
    //The player is navigating
    else
        [super ccTouchEnded:touch withEvent:event];
}


@end
