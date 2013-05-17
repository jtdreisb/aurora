//
//  AUTimelineChannel.h
//  Aurora
//
//  Created by Jason Dreisbach on 5/13/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AUTimeline;
@class AUEffect;

@interface AUTimelineChannel : NSObject <NSCoding>

@property (weak) AUTimeline *timeline;

- (void)addEffect:(AUEffect *)effect;

- (NSArray *)allEffects;

- (NSArray *)effectsFrom:(NSTimeInterval)begin to:(NSTimeInterval)end;

@end
