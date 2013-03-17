
#import "BlockFragmentSprite.h"
#import "ParticlesManager.h"

@implementation BlockFragmentSprite

-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect mass:(cpFloat) mass particleFile:(NSString*)file {
    
    if (self = [super initWithTexture:texture rect:rect mass:mass]) {
        particleFile = file;
        willBeRemoved = NO;
    }
    return self;
}

static NSInteger count = 0;

- (void) impactAtPoint:(CGPoint) p withDamage:(float) damage {
    
    if(willBeRemoved) return;
    
    if(damage > cpBodyGetMass(self.body) / 9){
        
        //2 chance sur 3 d'être remove si impact violent
        
        NSInteger r = (arc4random() % 100);
        if(r <= 66) {
            willBeRemoved = YES;
            [[Collector sharedInstance].spriteToRemove addObject:self];
            
            ++count;
            if (count == 4) {
                count = 0;
                CCParticleSystemQuad *broke = [[ParticlesManager sharedInstance] getParticle:particleFile];
                broke.position = self.position;
                broke.scale = 0.8;
                [self.parent addChild:broke z:99];
            }
            
          /*  
            
            [self showPointEarned];*/
        }
    }    
}

- (BOOL) canBeDivided {
    return YES;
}

@end
