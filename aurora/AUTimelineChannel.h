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
@class DPHueLight;

@interface AUTimelineChannel : NSObject <NSCoding>

@property (weak) AUTimeline *timeline;

@property (strong) DPHueLight *light;

- (void)addEffect:(AUEffect *)effect;
- (void)removeEffect:(AUEffect *)effect;

- (NSArray *)effects;

- (NSArray *)effectsFrom:(NSTimeInterval)begin to:(NSTimeInterval)end;

@end
