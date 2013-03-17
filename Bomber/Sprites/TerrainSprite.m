//
//  TerrainSprite.m
//  Bomber
//
//  Created by Robin Monjo on 12-05-21.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "TerrainSprite.h"

@implementation TerrainSprite

+ (TerrainSprite*) initWithRect:(CGRect) rect {
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"terrain_content.png"];
    return [TerrainSprite spriteWithTexture:texture rect:rect];
}


- (id) initWithTexture:(CCTexture2D*) texture rect:(CGRect) rect {
    if(self = [super initWithTexture:texture rect:rect]) {

        self.body = cpBodyNewStatic();
        
        //Converting points in chipmunk coordinates
        CGPoint p1 = CGPointMake(-rect.size.width/2, -rect.size.height/2);
        CGPoint p2 = CGPointMake(-rect.size.width/2, +rect.size.height/2);
        CGPoint p3 = CGPointMake(+rect.size.width/2, +rect.size.height/2);
        CGPoint p4 = CGPointMake(+rect.size.width/2, -rect.size.height/2);
                
        CGPoint verts[] = {p1, p2, p3, p4};
        
        self.shape = cpPolyShapeNew(self.body, 4, verts, cpvzero);
        cpShapeSetElasticity(self.shape, .1f);
        cpShapeSetFriction(self.shape, 1.0f);
        cpShapeSetUserData(self.shape, (__bridge cpDataPointer)(self));
        cpShapeSetCollisionType(self.shape, TERRAIN_COLLISION);
        
        CCSprite *top = [CCSprite spriteWithFile:@"terrain_top.png" rect:CGRectMake(0, 0, rect.size.width, 6)];
        ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
        [top.texture setTexParameters:&tp];
        top.position = CGPointMake(rect.size.width/2, rect.size.height-3);
        [self addChild:top];
    }
    ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
    [self.texture setTexParameters:&tp];
    return self;
}

@end
