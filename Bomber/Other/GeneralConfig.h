//
//  GameConfig.h
//  Bomber
//
//  Created by Robin Monjo on 11/3/11.
//  Copyright Polytech' Nice-Sophia 2011. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2


#define WALL_COLLISION 0
#define BOMB_COLLISION 1
#define PLAYER_COLLISION 2
#define EXPLOSION_COLLISION 3
#define TARGET_COLLISION 4
#define BLOCK_COLLISION 5
#define ANVIL_COLLISION 6
#define DRUM_COLLISION 7
#define POLY_COLLISION 8
#define END_POINT_COLLISION 9
#define BLOOD_SENSOR 10
#define KAMEA_COLLISION 11
#define FIRE_SENSOR 12
#define TERRAIN_COLLISION 13
#define STAR_SENSOR 14
#define FIRE_BALL_COLLISION 15
#define BLACK_HOLE_SENSOR 16
#define BOUNCING_BALL_COLLISION 17
#define BLOCK_ATOMIZER_SENSOR 18
#define GRENADE_COLLISION 19
#define GRENADE_FRAGMENT_COLLISION 20


//NODE TAGS
#define START_POINT 555
#define END_POINT 444
#define WEAPON_LAYER 333

//Macros
#define SCREEN_WIDTH ([[CCDirector sharedDirector] winSize].width)
#define SCREEN_HEIGHT ([[CCDirector sharedDirector] winSize].height)
#define CURRENT_LEVEL ([[TimeLine instance] currentLevel])
#define LAYER_RECT (CGRectMake(0, 0, self.contentSize.width, self.contentSize.height))

//Constant
static float const kAnimationDuration = 0.4;

//
// Define here the type of autorotation that you want for your game
//

// 3rd generation and newer devices: Rotate using UIViewController. Rotation should be supported on iPad apps.
// TIP:
// To improve the performance, you should set this value to "kGameAutorotationNone" or "kGameAutorotationCCDirector"
#if defined(__ARM_NEON__) || TARGET_IPHONE_SIMULATOR
#define GAME_AUTOROTATION kGameAutorotationCCDirector

// ARMv6 (1st and 2nd generation devices): Don't rotate. It is very expensive
#elif __arm__
#define GAME_AUTOROTATION kGameAutorotationNone


// Ignore this value on Mac
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

#else
#error(unknown architecture)
#endif

#endif // __GAME_CONFIG_H


