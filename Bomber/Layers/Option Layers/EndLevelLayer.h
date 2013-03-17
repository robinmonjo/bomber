//
//  EndLevelLayer.h
//  Bomber
//
//  Created by Robin Monjo on 9/14/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//


@interface EndLevelLayer : CCLayerColor

+ (EndLevelLayer *) init;

- (void) setPositionRelativeToBomberPosition:(CGPoint) bomberPos;

@end
