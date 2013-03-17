//
//  NSMutableArray+QueueAddition.m
//  Bomber
//
//  Created by Robin Monjo on 11/25/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import "NSMutableArray+QueueAddition.h"

@implementation NSMutableArray (QueueAddition)

// Queues are first-in-first-out, so we remove objects from the head
- (id) dequeue {
    if ([self count] == 0) return nil;
    
    id headObject = [self objectAtIndex:0];
    [self removeObjectAtIndex:0];
    return headObject;
}

- (NSMutableArray *) dequeue:(NSInteger)nb {
    if ([self count] == 0) return nil;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self subarrayWithRange:NSMakeRange(0, nb)]];
    [self removeObjectsInArray:array];
    return array;
}

// Add to the tail of the queue (no one likes it when people cut in line!)
- (void) enqueue:(id)anObject {
    [self addObject:anObject];
}

@end
