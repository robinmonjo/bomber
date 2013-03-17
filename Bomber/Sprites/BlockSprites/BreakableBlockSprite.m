
#import "BreakableBlockSprite.h"
#import "BlockFragmentSprite.h"

@interface BreakableBlockSprite()

//Macros
#define IS_VERTICAL (self.contentSize.width < self.contentSize.height)

//Const
#define FRAG_SIZE 4

#define DAMAGED_SPRITE_TAG 11

@end

@implementation BreakableBlockSprite

@synthesize zone1, zone2, zone3, preparedFrags=_preparedFrags;

-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
                                    mass:(cpFloat)mass resistance:(cpFloat) res particleFile:(NSString*)file{
    
    if(self = [super initWithTexture:texture rect:rect mass:mass]) {
        
        particleFile = file;
        resistance = res;
        
        //define zone
        if(IS_VERTICAL) {
            /*
                 __
                |  |  -->z1
                |  |
                |  |  -->z2
                |  |
                |__|  -->z3
                
            */
            zone1 = [[BlockZone alloc] initWithRect:CGRectMake(0, 2*self.contentSize.height/3,
                                                               self.contentSize.width, self.contentSize.height/3)
                     andResistance:resistance] ;
            
            zone2 = [[BlockZone alloc] initWithRect:CGRectMake(0, self.contentSize.height/3,
                                                               self.contentSize.width, self.contentSize.height/3)
                     andResistance:resistance];
            
            zone3 = [[BlockZone alloc] initWithRect:CGRectMake(0, 0,
                                                               self.contentSize.width, self.contentSize.height/3)
                     andResistance:resistance];
        }
        else {
            /*
             
             z1      z2     z3
             _________________
             |               |
             _________________
             
            */
            zone1 = [[BlockZone alloc] initWithRect:CGRectMake(0, 0,
                                                               self.contentSize.width/3, self.contentSize.height)
                     andResistance:resistance];
            
            zone2 = [[BlockZone alloc] initWithRect:CGRectMake(self.contentSize.width/3, 0,
                                                               self.contentSize.width/3, self.contentSize.height)
                     andResistance:resistance];
            
            zone3 = [[BlockZone alloc] initWithRect:CGRectMake(2*self.contentSize.width/3, 0,
                                                               self.contentSize.width/3, self.contentSize.height)
                     andResistance:resistance];
        }
        
    }
    return self;
}

- (void) prepareFragments {
    NSInteger nbFragMax = (self.contentSize.width / FRAG_SIZE) * (self.contentSize.height / FRAG_SIZE);
    self.preparedFrags = [NSMutableArray arrayWithCapacity:nbFragMax];
    for (NSInteger i = 0; i < nbFragMax; ++i) {
        BlockFragmentSprite *frag = [[BlockFragmentSprite alloc] initWithTexture:self.texture
                                                                            rect:CGRectMake(0, 0, FRAG_SIZE, FRAG_SIZE)
                                                                            mass:10
                                                                    particleFile:particleFile];
        [self.preparedFrags addObject:frag];
    }
}

- (BOOL) canBeDivided {
    return YES;
}

- (BlockZone *) getZoneForPoint:(CGPoint) p {
    if([zone1 isPointInZone:p])return zone1;
    else if([zone2 isPointInZone:p]) return zone2;
    else if([zone3 isPointInZone:p]) return zone3;
    else {
       // NSLog(@"has returned NIL !!!");
        return nil; //should not happen !!
    }
}

- (void) fragmentZone:(CGRect) rect {
        
    NSInteger hor = rect.size.width / FRAG_SIZE;
    NSInteger vert = rect.size.height / FRAG_SIZE;
    cpFloat newMass = (cpBodyGetMass(self.body)/3) / (hor*vert);
    NSInteger newPointEranedWhenDestroyed = (NSInteger) self.pointEarnedWhenDestroyed / (hor*vert);
        
    for(NSInteger i = 0; i < hor; ++i) {
        for(NSInteger j = 0; j < vert; ++j) {
            
            BlockFragmentSprite *frag;
            
            if (!self.preparedFrags || self.preparedFrags.count == 0) {
                frag = [[BlockFragmentSprite alloc] initWithTexture:self.texture
                                                               rect:CGRectMake(0, 0, FRAG_SIZE, FRAG_SIZE)
                                                               mass:newMass
                                                       particleFile:particleFile];
            }
            else {
                frag = [self.preparedFrags dequeue];
                cpBodySetMass(frag.body, newMass);
            }
                        
            frag.pointEarnedWhenDestroyed = newPointEranedWhenDestroyed;
                        
            frag.position = CGPointMake(rect.origin.x + i*FRAG_SIZE + 1, rect.origin.y + j*FRAG_SIZE + 1);
            frag.position = [self convertToWorldSpace:frag.position];
            /*
             Needed since parent layer may be dragged at the same time
             */
            frag.position = CGPointMake(frag.position.x - self.parent.position.x,
                                        frag.position.y - self.parent.position.y);
            frag.rotation = self.rotation;
            cpBodySetVel(frag.body, cpBodyGetVel(self.body));
            
            [[Collector sharedInstance].spriteToAdd addObject:frag];
            
            //adding children (eg: blood, smoke, ...)
            for(CCNode *child in self.children) {
                CGPoint p = [frag convertToNodeSpace:[self convertToWorldSpace:child.position]];
                if(CGRectContainsPoint(CGRectMake(0, 0, FRAG_SIZE, FRAG_SIZE), p) && child.tag != DAMAGED_SPRITE_TAG) {
                    CCNode *_child = child; //needed otherwise child get deallocated the line after !
                    [child removeFromParentAndCleanup:NO];
                    _child.position = p;
                    [frag addChild:_child];
                }
            }
        }
    }
}

- (void) generateBlockForRect:(CGRect) rect nbOfRect:(int) nb {
    
    cpFloat newMass = (cpBodyGetMass(self.body)/3) * nb;
    cpFloat newResistance = (resistance/3) * nb;
    NSInteger newPointEranedWhenDestroyed = (NSInteger) (self.pointEarnedWhenDestroyed / 3) * nb;
    
    BlockSprite *newBlock;
    
    if(rect.size.width <= 3*FRAG_SIZE && rect.size.height <= 3*FRAG_SIZE) {
        //to small to be conbsidered as block, fragment it
        newBlock = [[BlockFragmentSprite alloc] initWithTexture:self.texture
                                                    rect:rect
                                                    mass:newMass particleFile:particleFile];
    }
    else {
        newBlock = [[BreakableBlockSprite alloc] initWithTexture:self.texture rect:rect
                                                            mass:newMass resistance:newResistance particleFile:particleFile];
        if (nb == 2) {
            ((BreakableBlockSprite*)newBlock).preparedFrags = self.preparedFrags;
        }
        else {
            ((BreakableBlockSprite*)newBlock).preparedFrags = [self.preparedFrags dequeue:(NSInteger)self.preparedFrags.count/2];
        }
        
    }
    
    newBlock.pointEarnedWhenDestroyed = newPointEranedWhenDestroyed;
    
    CGPoint pos = CGPointMake(rect.origin.x + newBlock.contentSize.width/2, rect.origin.y + newBlock.contentSize.height/2);
        
    newBlock.position = [self convertToWorldSpace:pos];
    /*
     Needed since parent layer may be dragged at the same time
    */
    newBlock.position = CGPointMake(newBlock.position.x - self.parent.position.x,
                                    newBlock.position.y - self.parent.position.y);
    
    newBlock.rotation = self.rotation;
    cpBodySetVel(newBlock.body, cpBodyGetVel(self.body));
    
    [[Collector sharedInstance].spriteToAdd addObject:newBlock];
    
    //adding children (eg: blood, smoke, ...)
    for(CCNode *child in self.children) {
        CGPoint p = [newBlock convertToNodeSpace:[self convertToWorldSpace:child.position]];
        if(CGRectContainsPoint(CGRectMake(0, 0, rect.size.width, rect.size.height), p)) {
            CCNode *_child = child; //needed otherwise child get deallocated the line after !
            [child removeFromParentAndCleanup:NO];
            _child.position = p;
            [newBlock addChild:_child];
        }
    }
}


- (void) impactAtPoint:(CGPoint) p withDamage:(CGFloat) damage{
    
    //Converting from chipmunk to cocos2D coordinate system + converting to int
    p = CGPointMake((NSInteger)(p.x + self.contentSize.width/2), (int)(p.y + self.contentSize.height/2));
    
    BlockZone *damagedZone = [self getZoneForPoint:p];
    
    if([damagedZone isDestroyed] || !damagedZone) return; //previously destroyed
    
    [damagedZone addDamage:damage];
    
    BOOL isDestroyed = [damagedZone isDestroyed];
    
    if ([damagedZone shouldShowDamage] && !isDestroyed /*no need to show damage is block is destroyed */) {
        //change texture
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"terrain_content.png"];
        CCSprite *damagedSprite = [CCSprite spriteWithTexture:texture rect:damagedZone.rect];
        ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
        [damagedSprite.texture setTexParameters:&tp];
        
        damagedSprite.position = CGPointMake(damagedZone.rect.origin.x + damagedZone.rect.size.width/2,
                                             damagedZone.rect.origin.y + damagedZone.rect.size.height/2);
        damagedSprite.tag = DAMAGED_SPRITE_TAG;
        
        [self addChild:damagedSprite];

    }
    
    if (isDestroyed) {
        
        [self fragmentZone:damagedZone.rect];
        
        if(damagedZone == self.zone2) {
            
            [self generateBlockForRect:self.zone1.rect nbOfRect:1];
            [self generateBlockForRect:self.zone3.rect nbOfRect:1];
            
        }
        else if(damagedZone == self.zone1) {
            
            [self generateBlockForRect:CGRectUnion(self.zone2.rect, self.zone3.rect) nbOfRect:2];
            
        }
        else if(damagedZone == self.zone3) {
            
            [self generateBlockForRect:CGRectUnion(self.zone1.rect, self.zone2.rect) nbOfRect:2];
            
        }
        
        [[Collector sharedInstance] addSpriteToRemove:self];
    }

}

- (void) atomizeBlock {
    self.zone1.resistance = 0;
    [self fragmentZone:self.zone1.rect];
    self.zone2.resistance = 0;
    [self fragmentZone:self.zone2.rect];
    self.zone3.resistance = 0;
    [self fragmentZone:self.zone3.rect];
    
    [[Collector sharedInstance] addSpriteToRemove:self];
}

@end
