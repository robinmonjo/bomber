

#import "BlockZone.h"

@implementation BlockZone

@synthesize rect=_rect, resistance;

- (id) initWithRect:(CGRect) r andResistance:(CGFloat) res {
    
    if(self = [super init]) {
        self.rect = r;
        _isShowingDamage = NO;
        resistance = res;
        _damage = .0f;
    }
    return self;
}

#define OFFSET 2
- (BOOL) isPointInZone:(CGPoint) p {
    
    CGRect rectO = self.rect;
    rectO.origin.x-=OFFSET;
    rectO.origin.y-=OFFSET;
    rectO.size.width+=2*OFFSET;
    rectO.size.height+=2*OFFSET;
    
    return CGRectContainsPoint(rectO, p);
}

- (void) addDamage:(CGFloat) damage {
    _damage += damage;
}

- (BOOL) isDestroyed {
    return (resistance - _damage) <= 0;
}

- (BOOL) shouldShowDamage {
    if (!_isShowingDamage && (_damage >= resistance * .5f)) {
        _isShowingDamage = YES;
        return YES;
    }
    return NO;
}


@end
