//
//  AUEffectTimeline.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUTimeline.h"
#import "AUTimelineChannel.h"
#import "AUEffect.h"

#define kChannelsKey @"channels"

@implementation AUTimeline
{
    NSArrayController *_channelArrayController;
}

- (id)initWithContentsOfPath:(NSString *)filePath
{
    self = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (self == nil) {
        self = [self init];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _channelArrayController = [[NSArrayController alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self != nil) {
        [_channelArrayController addObjects:[aDecoder decodeObjectForKey:kChannelsKey]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_channelArrayController.arrangedObjects forKey:kChannelsKey];
}

- (void)writeToFile:(NSString *)filePath
{
    NSError *err = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&err];
    if (err != nil) {
        NSLog(@"%s: %@", __PRETTY_FUNCTION__, err);
    }
    else {
        [NSKeyedArchiver archiveRootObject:self toFile:filePath];
    }
}

- (NSArray *)channels
{
    return _channelArrayController.arrangedObjects;
}

- (void)addChannel:(AUTimelineChannel *)channel
{
    channel.timeline = self;
    [_channelArrayController addObject:channel];
}

- (void)removeChannel:(AUTimelineChannel *)channel
{
    [_channelArrayController remove:channel];
}

@end
