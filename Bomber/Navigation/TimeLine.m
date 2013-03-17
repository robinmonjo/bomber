
#import "TimeLine.h"

@implementation TimeLine

#define DOCUMENT_DIRECTORY ([NSHomeDirectory() stringByAppendingPathComponent:@"Documents"])

@synthesize currentLevel=_currentLevel, levels=_levels, director=_director;

static TimeLine *instance;

+ (TimeLine*) instance {
    @synchronized(self)
    {
        if (instance == NULL) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (id) init {
    if(self = [super init]) {
        
        self.director = (CCDirectorIOS*) [CCDirector sharedDirector];
        
        NSString *backupFile = [DOCUMENT_DIRECTORY stringByAppendingPathComponent:@"levels.archive"];
        BOOL backup = [[NSFileManager defaultManager] fileExistsAtPath:backupFile];
        if(backup)
            [self loadLevelsFromBackup];
        else {
            self.currentLevel = [[TransitionLevel  alloc] initWithBgFile:@"bg_transition.jpg"];
            GameLevel *l2 = [[GameLevel alloc] initWithNumber:1 andBgFile:@"fabric_texture.png"];
            GameLevel *l3 = [[GameLevel alloc] initWithNumber:2 andBgFile:@"fabric_texture.png"];
            GameLevel *l4 = [[GameLevel alloc] initWithNumber:3 andBgFile:@"fabric_texture.png"];
            GameLevel *l5 = [[GameLevel alloc] initWithNumber:4 andBgFile:@"fabric_texture.png"];
            GameLevel *l6 = [[GameLevel alloc] initWithNumber:5 andBgFile:@"fabric_texture.png"];
            GameLevel *l7 = [[GameLevel alloc] initWithNumber:6 andBgFile:@"fabric_texture.png"];
            GameLevel *l8 = [[GameLevel alloc] initWithNumber:7 andBgFile:@"fabric_texture.png"];
                
            self.levels = [NSArray arrayWithObjects:self.currentLevel, l2, l3, l4, l5, l6, l7, l8, nil];
        }
        
    }
    return self;
}

- (void) save {
    NSString *archivePath = [DOCUMENT_DIRECTORY stringByAppendingPathComponent:@"levels.archive"];
    [NSKeyedArchiver archiveRootObject:self.levels toFile:archivePath];
}

- (void) loadLevelsFromBackup {
    NSString *archivePath = [DOCUMENT_DIRECTORY stringByAppendingPathComponent:@"levels.archive"];
    self.levels = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    self.currentLevel = [self.levels objectAtIndex:0];
}


- (void) launchFirstLevel {
    [self.director pushScene:[self.currentLevel scene]];
}


- (BOOL) previousLevel {
    NSInteger currentLevelIndex = [self.levels indexOfObject:self.currentLevel];
    if(currentLevelIndex == 0) return NO;
    self.currentLevel = [self.levels objectAtIndex:currentLevelIndex - 1];
    [self.director replaceScene:[CCTransitionSlideInL transitionWithDuration:.4 scene:[self.currentLevel scene]]];
    return YES;
}

- (BOOL) nextLevel {
    NSInteger currentLevelIndex = [self.levels indexOfObject:self.currentLevel];
    if(currentLevelIndex == self.levels.count-1) return NO;
    
   // if(![self isLevelAccessible:[levels objectAtIndex:currentLevelIndex + 1]]) return NO;
    
    self.currentLevel = [self.levels objectAtIndex:currentLevelIndex + 1];
    [self.director replaceScene:[CCTransitionSlideInR transitionWithDuration:.4 scene:[self.currentLevel scene]]];
    return YES;
}

- (void) goToLevel:(Level *)level {
    self.currentLevel = level;
    [self.director replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:[self.currentLevel scene] withColor:ccc3(0, 0, 0)]];
}

- (GameLevel *) getGameLevelAfterLevel:(Level *)level {
    NSInteger indexCurLevel = [self.levels indexOfObject:level];
    for (NSInteger i = indexCurLevel + 1; i < self.levels.count; ++i) {
        Level *result = [self.levels objectAtIndex:i];
        if ([result isKindOfClass:[GameLevel class]]) {
            return (GameLevel *)result;
        }
    }
    
    return nil;
}

//TODO redo

- (BOOL) isLevelAccessible:(Level*) level {
    NSInteger index = [self.levels indexOfObject:level];

    if([level isKindOfClass:[GameLevel class]]) {
        if(index == 0)
            return YES;
        else if( [[self.levels objectAtIndex:index-1] isKindOfClass:[TransitionLevel class]] )
            return [self isLevelAccessible:[self.levels objectAtIndex:index-1]];
        else if( ((GameLevel*)[self.levels objectAtIndex:index-1]).passed )
            return YES;
    }
    else if([level isKindOfClass:[TransitionLevel class]]) {
        if(index == 0)
            return YES;
        else if(  [[self.levels objectAtIndex:index-1] isKindOfClass:[TransitionLevel class]] )
            return YES;
        else if( ((GameLevel*)[self.levels objectAtIndex:index-1]).passed )
            return YES;
    }
    return NO;
}



@end
