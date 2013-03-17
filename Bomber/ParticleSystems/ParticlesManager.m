
#import "ParticlesManager.h"

@implementation ParticlesManager

static ParticlesManager *instance;

+(ParticlesManager*) sharedInstance {
    @synchronized(self) {
        if(instance == nil) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

-(id) init {
    if((self=[super init])) {
        particlePool = [[NSMutableArray alloc] init];
        stringToTagMap = [[NSMutableDictionary alloc] init];
        maxTag = 0;
    }
    return self;
}


/*
 * This class will return an CCParticleSystemQuad with the 
 * supplied resource path i.e. .plist file. If a pooled 
 * system is available that will be returned. An system  
 * is considered available if it is inactive and has no 
 * active particles.
 */
-(CCParticleSystemQuad*) getParticle:(NSString *)file {
    NSNumber * tag = [stringToTagMap objectForKey:file];
    
    /* 
     * If the mapping doesn't exist in the dictionary add it. We use this
     * mapping because we want to define the particle type by it's .plist
     * file path but the CCParticleSystem object can only tag systems with
     * an int.
     */ 
    if(tag==nil) {
        tag = [NSNumber numberWithInt:maxTag++];
        [stringToTagMap setObject:tag forKey:file];
    }
    
    // If possible return a system from the pool
    CCParticleSystemQuad * system;
    
    // Search through the pool for an available object of the 
    // required type and if one is found return it
    for(system in particlePool) {
        if(system.tag==[tag intValue] && (system.particleCount==0) && !system.active) {
            [system removeFromParentAndCleanup:YES];
            [system resetSystem];
            [system unscheduleUpdate];
            [system scheduleUpdate];
            system.scale = 1;
            return system;
        }
    }
    
    // Otherwise return a new system
    system = [CCParticleSystemQuad particleWithFile:file];
    system.tag = [tag intValue];
    [particlePool addObject:system];
    
    return system;
}

@end
