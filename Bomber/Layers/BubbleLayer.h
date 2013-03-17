//
//  BubbleLayer.h
//  Bomber
//
//  Created by Robin Monjo on 12-02-28.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "CCLayer.h"

@interface BubbleLayer : CCLayerColor {
@private
    //Info
    CCSprite *infoSprite;
    CCMenuItemFont *text;
    //Graphic
    CCSprite *topBar;
    CCSprite *bottomBar;
    CCSprite *leftBar;
    CCSprite *rightBar;
   // CCSprite *arrow;

}

- (id) initWithText:(NSString*) t andSprite:(NSString *) file;

- (void) updateText:(NSString *)t;
- (void) show;
- (void) hideAndRemove;
    
@end
