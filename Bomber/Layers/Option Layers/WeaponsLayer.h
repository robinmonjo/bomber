
#import "TimeLine.h"
#import "BubbleLayer.h"
#import "WeaponSpriteProtocol.h"

#define WEAPONS_LAYER_HEIGHT 60

@interface WeaponsLayer : CCLayer <CCTargetedTouchDelegate> {

@private
    NSMutableArray *weapons;
    
    CCSprite<WeaponSpriteProtocol> *selectedWeapon;
    BubbleLayer *bubbleLayer;
}

- (id) initWithWeapons:(NSMutableArray*) weap;

@end
