//
//  NSMutableArray+QueueAddition.h
//  Bomber
//
//  Created by Robin Monjo on 11/25/12.
//  Copyright (c) 2012 Polytech' Nice-Sophia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (QueueAddition)

- (id) dequeue;
- (NSMutableArray *) dequeue:(NSInteger)nb;
- (void) enqueue:(id)obj;

@end
