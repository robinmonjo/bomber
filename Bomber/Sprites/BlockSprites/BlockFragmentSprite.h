
#import "BlockSprite.h"

@interface BlockFragmentSprite : BlockSprite {
@private
    NSString *particleFile;
    BOOL willBeRemoved;
}

-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect mass:(cpFloat) mass particleFile:(NSString*)file;

@end
