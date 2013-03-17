
#import "GameLevel.h"
#import "GameLayer.h"
#import "ThumbLevelLayer.h"

@implementation GameLevel

@synthesize passed=_passed, number, weapons, nbStars=_nbStars, locked=_locked, thumbView=_thumbView;

- (id) initWithNumber:(int) n andBgFile:(NSString*) bg{
    
    if (self = [super initWithBgFile:bg]) {
        number = n;
        _passed = NO;
        weapons = [NSMutableArray array];
        label = [NSString stringWithFormat:@"Level %i",n];
        _nbStars = 0;
    }
    return self;
}

- (CCScene *) scene {
    return [GameLayer sceneWithLevel:self];
}

- (void) encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeInt:number forKey:@"number"];
    [coder encodeBool:_passed forKey:@"passed"];
    [coder encodeBool:_locked forKey:@"locked"];
    [coder encodeInt:_nbStars forKey:@"nb_stars"];
}

- (GameLevel*) initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    number = [decoder decodeIntForKey:@"number"];
    _passed = [decoder decodeBoolForKey:@"passed"];
    _locked = [decoder decodeBoolForKey:@"locked"];
    weapons = [NSMutableArray array];
    _nbStars = [decoder decodeIntForKey:@"nb_stars"];
    return self;
}

- (void) setNbStars:(int)nbStars {
    _nbStars = nbStars;
    [self.thumbView updateStarsAnimated:YES];
}

- (void) setPassed:(BOOL)passed {
    _passed = passed;
    [self.thumbView showLevelPassedAnimated:YES];
}

- (void) setLocked:(BOOL)locked {
    self.locked = _locked;
    if (!self.locked) {
        [self.thumbView showUnlock];
    }
}

@end
