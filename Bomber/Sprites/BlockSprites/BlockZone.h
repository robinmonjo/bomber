

@interface BlockZone : NSObject {
@private
    CGRect _rect;
    CGFloat resistance;
    CGFloat _damage;
    BOOL _isShowingDamage;
}

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGFloat resistance;

- (id) initWithRect:(CGRect) r andResistance:(CGFloat) res;

- (BOOL) isPointInZone:(CGPoint) p;

- (void) addDamage:(CGFloat) damage;

- (BOOL) isDestroyed;
- (BOOL) shouldShowDamage;

@end
