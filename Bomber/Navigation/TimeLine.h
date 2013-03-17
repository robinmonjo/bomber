#import "Level.h"
#import "TransitionLevel.h"
#import "GameLevel.h"

@interface TimeLine : NSObject {
    NSArray *_levels;
    Level *_currentLevel;
    CCDirectorIOS *_director;
}

@property (nonatomic, retain) Level *currentLevel;
@property (nonatomic, retain) NSArray *levels;
@property (nonatomic, retain) CCDirectorIOS *director;

+ (TimeLine*) instance;

- (void) launchFirstLevel;
- (BOOL) previousLevel;
- (void) goToLevel:(Level *)level;
- (BOOL) nextLevel;

- (void) save;
- (void) loadLevelsFromBackup;

- (BOOL) isLevelAccessible:(Level*) level;
- (GameLevel *) getGameLevelAfterLevel:(Level *)level;

@end
