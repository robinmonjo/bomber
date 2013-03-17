
#import "WeaponsLayer.h"


@interface WeaponsLayer ()

#define CASE_WIDTH 60
#define BUBBLE_OFFSET 50

- (void) updateDisplayAnimated:(BOOL)animated;

@end


@implementation WeaponsLayer

- (id) initWithWeapons:(NSMutableArray *)weap {
    
    if(self = [super init]) {
        
        weapons = weap;
        
        self.isTouchEnabled = YES;
        [self setContentSize:CGSizeMake(CASE_WIDTH*weapons.count, WEAPONS_LAYER_HEIGHT)];
        
        //Position the layer
        [self setPosition:CGPointMake((SCREEN_WIDTH - self.contentSize.width)/2, -WEAPONS_LAYER_HEIGHT)];
        
        [self updateDisplayAnimated:NO];
    }
    return self;
}


//Update the display of weapons inside the layer
- (void) updateDisplayAnimated:(BOOL)animated {
   
    float width = self.contentSize.width / weapons.count;

    
    for(int i = 0; i < weapons.count; i++) {
        
        CCSprite *sprite = [weapons objectAtIndex:i];
        
        if(sprite != selectedWeapon) {
            CGPoint futurePosition = CGPointMake(i*width + width/2, WEAPONS_LAYER_HEIGHT/2);
            
            //Animation of replacement
            CGFloat dx = sprite.position.x - futurePosition.x;
            CGFloat dy = sprite.position.y - futurePosition.y;
            CGFloat distance = sqrt(dx*dx + dy*dy);
            CGFloat duration = !animated ? 0 : distance/SCREEN_WIDTH;
            
            //Replace the sprite with the animation
            CCAction *replaceAction= [CCMoveTo actionWithDuration:duration position:futurePosition];
            [sprite runAction:replaceAction];
            sprite.scale = 1;
            
            //If init, add the sprite to the layer
            if(!animated)
                [self addChild:sprite];
        }
    }
}

//Get the selected case according to a x coordinate
- (int) selectedCase:(float) x {
    int caseWidth = self.contentSize.width / weapons.count;
    for (int i = caseWidth; i <= self.contentSize.width; i += caseWidth) {
        if (x <= i)
            return i/caseWidth - 1;
    }
    NSAssert(x >= 0 && x < weapons.count, @"Error weapons layer selectedCase", nil);
    return -1; //never happen !
}


- (void) changeWeaponsOrderFromeCase:(int)originalCase toCase:(int)selectedCase {
    //If the new case is different from the previous one, change weapons order in the array
    if(originalCase != selectedCase) {
        [weapons removeObjectAtIndex:originalCase];
        [weapons insertObject:selectedWeapon atIndex:selectedCase];
        //Update the display
        [self updateDisplayAnimated:YES];
    }
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint p = [self convertTouchToNodeSpace:touch];
    
    if(!CGRectContainsPoint(LAYER_RECT, p)) return NO; //Touch occured outside the layer, don't claim the touch
    
    if(weapons.count == 0) return NO; //No weapons, coses crash if processed (division by 0)
    
    //Touch occured inside the layer, handle it and claim it
    int selectedCase = [self selectedCase:p.x];
    selectedWeapon = [weapons objectAtIndex:selectedCase];
    selectedWeapon.scale = 2.3;
    
    bubbleLayer = [[BubbleLayer alloc] initWithText:[NSString stringWithFormat:@"%@ %i/%i",
                                                     selectedWeapon.label,
                                                     selectedCase + 1,
                                                     weapons.count]
                                          andSprite:selectedWeapon.file];
    
    [bubbleLayer setPosition:CGPointMake(p.x-(bubbleLayer.contentSize.width/2), p.y+BUBBLE_OFFSET)];
    [self addChild:bubbleLayer z:INT_MAX];
    [bubbleLayer show];
        
    return YES;
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint p = [self convertTouchToNodeSpace:touch];
    
    //Move the weapon
    [selectedWeapon setPosition:p];
    [bubbleLayer setPosition:CGPointMake(p.x-(bubbleLayer.contentSize.width/2), p.y+BUBBLE_OFFSET)];
    
    //If the weapon has moved outside the layer, do nothing
    if(!CGRectContainsPoint(LAYER_RECT, p)) return;
    
    //Else
    //Get the new case
    int selectedCase = [self selectedCase:p.x];
    int originalCase = [weapons indexOfObject:selectedWeapon];
    if (selectedCase != originalCase) {
        [self changeWeaponsOrderFromeCase:originalCase toCase:selectedCase];
        [bubbleLayer updateText:[NSString stringWithFormat:@"%@ %i/%i",
                              selectedWeapon.label,
                              selectedCase + 1,
                              weapons.count]];
    }
    
    
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //If no weapons selected, do nothing
    if(!selectedWeapon) return;
    
    //Else
    CGPoint p = [self convertTouchToNodeSpace:touch];
    //If the touch is inside the layer, update weapon's order
    if(CGRectContainsPoint(LAYER_RECT, p)) {
        int selectedCase = [self selectedCase:p.x];
        int originalCase = [weapons indexOfObject:selectedWeapon];
        [self changeWeaponsOrderFromeCase:originalCase toCase:selectedCase];
    }
    
    selectedWeapon = nil;
    
    //Update display
    [self updateDisplayAnimated:YES];
    [bubbleLayer hideAndRemove];
}


-(void) registerWithTouchDispatcher {
	[[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

@end
