

#import "BubbleLayer.h"

@interface BubbleLayer()

#define MARGIN 5
#define ELEMENTS_HEIGHT 24 //defined according to text font

- (void) initText:(NSString*) t;
- (void) initSprite:(NSString *) file;
- (void) updateBorders;
- (void) updateContentSize;
- (void) adjustSpriteSizeToLayer;

@end;

@implementation BubbleLayer



- (id) initWithText:(NSString*) t andSprite:(NSString *) file {
    
    if(self = [super initWithColor:ccc4(255, 255, 255, 200)]) {
        
        if(t) {
            [self initText:t];
            [self addChild:text];
        }
        if(file) {
            [self initSprite:file];
            [self addChild:infoSprite];
        }
        
        topBar = [CCSprite spriteWithFile:@"bar_horiz.png"];
        bottomBar = [CCSprite spriteWithFile:@"bar_horiz.png"];
        leftBar = [CCSprite spriteWithFile:@"bar_vert.png"];
        rightBar = [CCSprite spriteWithFile:@"bar_vert.png"];
        [self addChild:topBar];
        [self addChild:bottomBar];
        [self addChild:leftBar];
        [self addChild:rightBar];
        
       // arrow = [CCSprite spriteWithFile:@"white_arrow.png"];
       // [self addChild:arrow];
        
        [self updateContentSize];
    }
    return self;
}

- (void) initText:(NSString*) t {
    text = [CCMenuItemFont itemWithString:t];
    [text setFontSize:20];
    [text setFontName:@"Helvetica"];
    [text setColor:ccc3(0, 0, 0)];
}

- (void) initSprite:(NSString *) file {
    infoSprite = [CCSprite spriteWithFile:file];
    [self adjustSpriteSizeToLayer];
}

- (void) updateContentSize {
    float layerWidth;
    
    if(text && infoSprite) {
        layerWidth = 3*MARGIN + infoSprite.contentSize.width + text.contentSize.width;
        text.position = CGPointMake(MARGIN + infoSprite.contentSize.width + MARGIN + text.contentSize.width/2,
                                    (2*MARGIN + ELEMENTS_HEIGHT)/2);
        infoSprite.position = CGPointMake(MARGIN + infoSprite.contentSize.width/2,
                                          (2*MARGIN + ELEMENTS_HEIGHT)/2);
        
    }
    else if(text && !infoSprite) {
        layerWidth = 2*MARGIN + text.contentSize.width;
        text.position = CGPointMake(MARGIN + text.contentSize.width/2,
                                    (2*MARGIN + ELEMENTS_HEIGHT)/2);
        
    }
    else {
        layerWidth = 2*MARGIN + infoSprite.contentSize.width;
        infoSprite.position = CGPointMake(MARGIN + infoSprite.contentSize.width/2, (2*MARGIN + ELEMENTS_HEIGHT)/2);
    }
    
    [self setContentSize:CGSizeMake(layerWidth, 2*MARGIN + ELEMENTS_HEIGHT)];
    [self updateBorders];
}

- (void) updateBorders {
    topBar.scaleX = self.contentSize.width / topBar.contentSize.width;
    bottomBar.scaleX = self.contentSize.width / bottomBar.contentSize.width;
    leftBar.scaleY = self.contentSize.height / leftBar.contentSize.height;
    rightBar.scaleY = self.contentSize.height / rightBar.contentSize.height;
    
    topBar.position = CGPointMake(self.contentSize.width/2, self.contentSize.height - topBar.contentSize.height/2);
    bottomBar.position = CGPointMake(self.contentSize.width/2, topBar.contentSize.height/2);
    leftBar.position = CGPointMake(leftBar.contentSize.width/2, self.contentSize.height/2);
    rightBar.position = CGPointMake(self.contentSize.width - rightBar.contentSize.width/2, self.contentSize.height/2);
    
    //arrow.position = CGPointMake(arrow.contentSize.width/2 + MARGIN, -arrow.contentSize.height/2 + bottomBar.contentSize.height);
}

- (void) adjustSpriteSizeToLayer {
    if(infoSprite.contentSize.width > infoSprite.contentSize.height)
        infoSprite.scale = ELEMENTS_HEIGHT / infoSprite.contentSize.width;
    else
        infoSprite.scale = ELEMENTS_HEIGHT / infoSprite.contentSize.height;

}

- (void) updateText:(NSString *)t {
    NSAssert(text, @"Error weapons layer selectedCase", nil);
    
    [text setString:t];
    [self updateContentSize];
    [self updateBorders];
}

- (void) show {
    //In case the layer was executing its hide action
    [self stopAllActions];
    self.scale = 0.1;
    CCAction *scaleUp = [CCScaleTo actionWithDuration:0.2 scale:1];
    [self runAction:scaleUp];
}

- (void) hideAndRemove {
    [self runAction:[CCScaleTo actionWithDuration:0.2 scale:0]];
    [self removeFromParentAndCleanup:YES];
}





@end
