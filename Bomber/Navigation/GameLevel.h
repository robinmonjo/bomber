//
//  GameLevel.h
//  Bomber
//
//  Created by Robin Monjo on 12-03-19.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "Level.h"

@class ThumbLevelLayer;

@interface GameLevel : Level {
@private
    NSInteger number;
    BOOL _passed;
    BOOL _locked;
    NSMutableArray *weapons;
    NSInteger _nbStars;
    
    ThumbLevelLayer *_thumbView;

}

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) BOOL passed;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, retain) NSMutableArray *weapons;
@property (nonatomic, assign) NSInteger nbStars;
@property (nonatomic, retain) ThumbLevelLayer *thumbView;


- (id) initWithNumber:(int) n andBgFile:(NSString*) bg;

@end
