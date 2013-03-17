
#import "WorldBuilder.h"
#import "BlockSpriteFactory.h"

@implementation WorldBuilder

static WorldBuilder *worldBuilder = NULL;

+ (WorldBuilder *)instance
{
    @synchronized(self)
    {
        if (worldBuilder == NULL)
            worldBuilder = [[self alloc] init];
    }
    
    return worldBuilder;
}

-(void) buildWorldNumber:(int) n layer:(GameLayer *) layer  {
    GameLevel *level = (GameLevel*)[[TimeLine instance] currentLevel];
    switch (n) {
        case 1: {
            
            [level.weapons removeAllObjects];
            [level.weapons addObject:[BombSprite init]];
            [level.weapons addObject:[AnvilSprite init]];
            [level.weapons addObject:[AnvilSprite init]];
            [level.weapons addObject:[BombSprite init]];
            [level.weapons addObject:[BombSprite init]];
            [level.weapons addObject:[BombSprite init]];
            
            BlockSprite *block = [BlockSpriteFactory createHighMassSolidBlockWithRect:CGRectMake(0, 0, 40, 40)];
            [layer addBlockSprite:block position:CGPointMake(200, 20)];
            
            BlockSprite *block2 = [BlockSpriteFactory createMediumMassBreakableBlockWithRect:CGRectMake(0, 0, 30, 60)];
            [layer addBlockSprite:block2 position:CGPointMake(300, 30)];
            
            //Set end points
            [layer addEndPointAtPosition:CGPointMake(15, 180) tag:START_POINT];
            [layer addEndPointAtPosition:CGPointMake(480-15, 70) tag:END_POINT];

    
            [layer addDrumSpriteAtPosition:CGPointMake(280,10)];
            [layer addDrumSpriteAtPosition:CGPointMake(380,10)];
            
            [layer addTargetSpriteAtPosition:CGPointMake(200, 45)];
            [layer addTargetSpriteAtPosition:CGPointMake(190, 45)];
            [layer addTargetSpriteAtPosition:CGPointMake(210, 45)];
            [layer addTargetSpriteAtPosition:CGPointMake(240, 0)];
            
            
            break;
        }
        case 2:
            
            [layer addBlockSprite:[BlockSpriteFactory createMediumMassBreakableBlockWithRect:CGRectMake(0, 0, 10, 40)]
                                                                                    position:CGPointMake(30, 20)];
            
            [layer addBlockSprite:[BlockSpriteFactory createMediumMassBreakableBlockWithRect:CGRectMake(0, 0, 10, 40)]
                                                                                    position:CGPointMake(70, 20)];
            
            [layer addBlockSprite:[BlockSpriteFactory createMediumMassBreakableBlockWithRect:CGRectMake(0, 0, 40, 10)]
                                                                                    position:CGPointMake(50, 45)];
            
            
            [layer addTargetSpriteAtPosition:CGPointMake(50, 9)];
            
            [layer addBlockSprite:[BlockSpriteFactory createHighMassBreakableBlockWithRect:CGRectMake(0, 0, 20, 100)]
                                                                                    position:CGPointMake(240, 50)];
            
            [layer addBlockSprite:[BlockSpriteFactory createHighMassBreakableBlockWithRect:CGRectMake(0, 0, 140, 10)]
                                                                                    position:CGPointMake(240, 105)];
                        
            for(int j = 0; j<6; j++) {
                for(int i = 0; i < 15; i++)
                    [layer addBlockSprite:[BlockSpriteFactory createHighMassSolidBlockWithRect:CGRectMake(0, 0, 6, 6)]
                                                                                            position:CGPointMake(200+(i*6), 111+(j*6))];
                
            }
            
            for (int i = 0; i < 5; i++) {
                [layer addTargetSpriteAtPosition:CGPointMake(390+(i*18), 0+9)];
            }
            
            [layer addDrumSpriteAtPosition:CGPointMake(270, 7)];
            
            //Set end points
            [layer addEndPointAtPosition:CGPointMake(15, 180) tag:START_POINT];
            [layer addEndPointAtPosition:CGPointMake(480-15, 70) tag:END_POINT];
            [level.weapons removeAllObjects];
            
            [level.weapons addObject:[KameaSprite init]];
            [level.weapons addObject:[BlockAtomiserSprite init]];
            [level.weapons addObject:[KameaSprite init]];
            [level.weapons addObject:[FireBallSprite init]];
            break;
            
        case 3:
            for (int j = 0; j < 3; j++) {
                for(int i = 0; i < 4; i++) {
                    [layer addBlockSprite:[BlockSpriteFactory createLowMassBreakableBlockWithRect:CGRectMake(0, 0, 10, 40)]
                                 position:CGPointMake(90+(j*110), 20+(i*50))];
                    
                    [layer addBlockSprite:[BlockSpriteFactory createMediumMassBreakableBlockWithRect:CGRectMake(0, 0, 10, 40)]
                                 position:CGPointMake(130+(j*110), 20+(i*50))];
                    
                    [layer addBlockSprite:[BlockSpriteFactory createLowMassBreakableBlockWithRect:CGRectMake(0, 0, 50, 10)]
                                 position:CGPointMake(110+(j*110), 45+(i*50))];

                    [layer addTargetSpriteAtPosition:CGPointMake(110+(j*110), (i*50)+9)];
                }
            }
            

            [layer addDrumSpriteAtPosition:CGPointMake(340, 7)];
            [layer addDrumSpriteAtPosition:CGPointMake(440, 7)];
            [layer addDrumSpriteAtPosition:CGPointMake(80, 7)];
            [layer addDrumSpriteAtPosition:CGPointMake(140, 7)];
            
            [layer addEndPointAtPosition:CGPointMake(15, 5) tag:START_POINT];
            [layer addEndPointAtPosition:CGPointMake(480-15, 270) tag:END_POINT];
            [level.weapons removeAllObjects];
            [level.weapons addObject:[KameaSprite init]];
            [level.weapons addObject:[KameaSprite init]];
            [level.weapons addObject:[FireBallSprite init]];
            [level.weapons addObject:[AnvilSprite init]];
            break;
            
        case 4:
            
            //Set end points
            [layer addEndPointAtPosition:CGPointMake(15, 180) tag:START_POINT];
            [layer addEndPointAtPosition:CGPointMake(480-15, 70) tag:END_POINT];
            
            [level.weapons removeAllObjects];
            [level.weapons addObject:[BlockAtomiserSprite init]];
            [level.weapons addObject:[AnvilSprite init]];

            [layer addBlockSprite:[BlockSpriteFactory createHighMassBreakableBlockWithRect:CGRectMake(0, 0, 8, 320)]
                         position:CGPointMake(360, 160)];
            
            [layer addTargetSpriteAtPosition:CGPointMake(380, 5)];
            [layer addTargetSpriteAtPosition:CGPointMake(400, 5)];
            
            break;
            
        case 5:
            
            //Set end points
            [layer addEndPointAtPosition:CGPointMake(15, 180) tag:START_POINT];
            [layer addEndPointAtPosition:CGPointMake(330, 5) tag:END_POINT];
            
            
            [layer addBlockSprite:[BlockSpriteFactory createHighMassSolidBlockWithRect:CGRectMake(0, 0, 10, 290)]
                         position:CGPointMake(350, 145)];
            [layer addTargetSpriteAtPosition:CGPointMake(380, 5)];
            
            [level.weapons removeAllObjects];
            [level.weapons addObject:[BouncingBallSprite init]];
            [level.weapons addObject:[BouncingBallSprite init]];
            
            break;
            
        case 6:
            //Set end points
            [layer addEndPointAtPosition:CGPointMake(15, 90) tag:START_POINT];
            [layer addEndPointAtPosition:CGPointMake(465, 90) tag:END_POINT];
            
            [layer addTerrainSpriteWithRect:CGRectMake(0, 0, 440, 10) atPosition:CGPointMake(240, 75)];
            
            for (int i = 0; i < 10; ++i) {
                [layer addTargetSpriteAtPosition:CGPointMake(i*30 + 20, 10)];
            }
            
            [level.weapons removeAllObjects];
            [level.weapons addObject:[BlackHoleSprite init]];
            [level.weapons addObject:[BlackHoleSprite init]];
            [level.weapons addObject:[BlackHoleSprite init]];
            
            break;
            
        case 7:
            
            for (int j = 0; j < 3; j++) {
                for(int i = 0; i < 4; i++) {
                    [layer addBlockSprite:[BlockSpriteFactory createLowMassBreakableBlockWithRect:CGRectMake(0, 0, 10, 40)]
                                 position:CGPointMake(90+(j*110), 20+(i*50))];
                    
                    [layer addBlockSprite:[BlockSpriteFactory createMediumMassBreakableBlockWithRect:CGRectMake(0, 0, 10, 40)]
                                 position:CGPointMake(130+(j*110), 20+(i*50))];
                    
                    [layer addBlockSprite:[BlockSpriteFactory createLowMassBreakableBlockWithRect:CGRectMake(0, 0, 50, 10)]
                                 position:CGPointMake(110+(j*110), 45+(i*50))];
                    
                    [layer addTargetSpriteAtPosition:CGPointMake(110+(j*110), (i*50)+9)];
                }
            }
            
            
            [layer addDrumSpriteAtPosition:CGPointMake(340, 7)];
            [layer addDrumSpriteAtPosition:CGPointMake(440, 7)];
            [layer addDrumSpriteAtPosition:CGPointMake(80, 7)];
            [layer addDrumSpriteAtPosition:CGPointMake(140, 7)];
            
            [layer addEndPointAtPosition:CGPointMake(15, 5) tag:START_POINT];
            [layer addEndPointAtPosition:CGPointMake(480-15, 270) tag:END_POINT];
            [level.weapons removeAllObjects];
            [level.weapons addObject:[BombSprite init]];
            [level.weapons addObject:[AnvilSprite init]];
            [level.weapons addObject:[BlackHoleSprite init]];
            [level.weapons addObject:[KameaSprite init]];
            [level.weapons addObject:[FireBallSprite init]];
            [level.weapons addObject:[BouncingBallSprite init]];
            [level.weapons addObject:[BlockAtomiserSprite init]];
            [level.weapons addObject:[GrenadeSprite init]];
            
            
            
            break;
            
        default:
            break;
    }
    
}

@end
