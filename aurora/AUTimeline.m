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
    NSMutableArray *_channels;
}

@synthesize channels = _channels;

- (id)initWithContentsOfPath:(NSString *)filePath
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data != nil) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self = [self initWithCoder:unarchiver];
    }
    else {
        self = [self init];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _channels = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self != nil) {
        _channels = [aDecoder decodeObjectForKey:kChannelsKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_channels forKey:kChannelsKey];
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

#pragma mark - Channel Management

- (void)addNewChannel
{
    [self willChangeValueForKey:@"channels"];
    [_channels addObject:[[AUTimelineChannel alloc] init]];
    [self didChangeValueForKey:@"channels"];
}

- (void)removeChannel:(AUTimelineChannel *)channelToRemove
{
    [self willChangeValueForKey:@"channels"];
    [_channels removeObject:channelToRemove];
    [self didChangeValueForKey:@"channels"];
}


@end
