/*
 class based on the tuto: http://www.deluge.co/?q=reuse-particle-emitter-cocos2d
*/

@interface ParticlesManager : NSObject {
@private
    
    // Map the file name of the emmitter to a tag number which will be set on the emitter
    NSMutableDictionary * stringToTagMap;
    
    // Array to store a pool of particles
    NSMutableArray * particlePool;
    
    // Store the maximum tag used
    NSInteger maxTag;
}

+(ParticlesManager*) sharedInstance;

-(CCParticleSystemQuad*) getParticle:(NSString *)file;


@end
