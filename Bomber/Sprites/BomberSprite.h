
#import "BombSprite.h"
#import "AnvilSprite.h"
#import "KameaSprite.h"
#import "FireBallSprite.h"
#import "BlackHoleSprite.h"
#import "BouncingBallSprite.h"

@class GameLayer;

@interface BomberSprite : PhysicSprite {
@private
    BOOL isMoving;
    BOOL hasStoppedMoving;
    
    BOOL isWaitingToLaunchAWeapon;
    
    //Point used to apply an impulse when the sprite reach the end of its path
    CGPoint p1 ; //last one
    CGPoint p2  ; //penultimate
    
    NSMutableArray *_path;
}

@property (nonatomic, retain) NSMutableArray *path;
@property (readonly, assign) BOOL isMoving;
@property (readonly, assign) BOOL hasStoppedMoving;
@property (readonly, assign) BOOL isWaitingToLaunchAWeapon;

+(BomberSprite*) init;

- (void) hasCollide;
- (void) moveToLocation;

- (void) dropWeapon:(CCSprite<WeaponSpriteProtocol> *) weapon inLayer:(GameLayer*) layer;
- (void) launchWeapon:(LaunchableWeaponSprite *)launchableWeapon inDirection:(CGPoint) direction;

@end
