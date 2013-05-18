//
//  AUTimelineChannel.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/13/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUTimelineChannel.h"
#import "AUEffect.h"
#import <DPHueLight.h>

#define kEffectsArrayKey @"effectsArrayController"

@implementation AUTimelineChannel
{
    NSArrayController *_effectArrayController;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _effectArrayController = [[NSArrayController alloc] init];
        NSSortDescriptor *sortdescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
        [_effectArrayController setSortDescriptors:@[sortdescriptor]];
        // Stuff with a fake bridge
        _light = [[DPHueLight alloc] initWithBridge:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self != nil) {
        _effectArrayController = [aDecoder decodeObjectForKey:kEffectsArrayKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_effectArrayController forKey:kEffectsArrayKey];
}

#pragma mark - Effect Management

- (void)addEffect:(AUEffect *)effect
{
    [_effectArrayController addObject:effect];
}

- (void)removeEffect:(AUEffect *)effect
{
    [_effectArrayController removeObject:effect];
}

- (NSArray *)allEffects
{
    return _effectArrayController.arrangedObjects;
}

- (NSArray *)effectsFrom:(NSTimeInterval)begin to:(NSTimeInterval)end
{
    NSMutableArray *effects  = [NSMutableArray array];
    for (AUEffect *effect in _effectArrayController.arrangedObjects) {
        if (effect.startTime > end)
            break;
        if (effect.startTime >= begin) {
            [effects addObject:effect];
        }
    }
    return effects;
}

@end
