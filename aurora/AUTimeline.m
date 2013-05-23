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
#define kDurationKey @"duration"
#define kZoomLevelKey @"zoom"

@implementation AUTimeline
{
    NSArrayController *_channelArrayController;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _channelArrayController = [[NSArrayController alloc] init];
        _zoomLevel = 1.0;
    }
    return self;
}

- (id)initWithContentsOfPath:(NSString *)filePath
{
    id archivedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    self = archivedObject == nil ? [self init] : archivedObject;
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self != nil) {
        [_channelArrayController addObjects:[aDecoder decodeObjectForKey:kChannelsKey]];
        for (AUTimelineChannel *channel in _channelArrayController.arrangedObjects) {
            channel.timeline = self;
        }
        _duration = [aDecoder decodeDoubleForKey:kDurationKey];
        _zoomLevel = [aDecoder decodeDoubleForKey:kZoomLevelKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_channelArrayController.arrangedObjects forKey:kChannelsKey];
    [aCoder encodeDouble:_duration forKey:kDurationKey];
    [aCoder encodeDouble:_zoomLevel forKey:kZoomLevelKey];
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
