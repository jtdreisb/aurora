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

#define kEffectsArrayKey @"effectsArray"

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
        [_effectArrayController addObjects:[aDecoder decodeObjectForKey:kEffectsArrayKey]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_effectArrayController.arrangedObjects forKey:kEffectsArrayKey];
}

#pragma mark - Effect Management

- (void)addEffect:(AUEffect *)effect
{
    [self willChangeValueForKey:@"effects"];
    [_effectArrayController addObject:effect];
    [self didChangeValueForKey:@"effects"];
}

- (void)removeEffect:(AUEffect *)effect
{
    [self willChangeValueForKey:@"effects"];
    [_effectArrayController removeObject:effect];
    [self didChangeValueForKey:@"effects"];
}

- (NSArray *)effects
{
    return _effectArrayController.arrangedObjects;
}

- (NSArray *)effectsFrom:(NSTimeInterval)begin to:(NSTimeInterval)end
{
    return [[_effectArrayController.arrangedObjects objectsPassingTest:^BOOL(AUEffect *effect, BOOL *stop) {
        if (effect.startTime >= begin && effect.startTime < end) {
            return YES;
        }
        return NO;
    }] allObjects];
}

@end
