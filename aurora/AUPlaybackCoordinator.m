//
//  AUPlaybackCoordinator.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUPlaybackCoordinator.h"

@implementation AUPlaybackCoordinator
{
    dispatch_queue_t _lightEffectQueue;
}

static AUPlaybackCoordinator *sharedInstance = nil;

+ (id)sharedInstance
{
    return sharedInstance;
}

+ (id)initializeSharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AUPlaybackCoordinator alloc] initWithPlaybackSession:[SPSession sharedSession]];
        sharedInstance.volume = 1.0;
    });
    return sharedInstance;
}

- (id)initWithPlaybackSession:(SPSession *)aSession
{
    self = [super initWithPlaybackSession:aSession];
    if (self != nil) {
        _lightEffectQueue = dispatch_queue_create("com.apple.aurora.lights.q", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)sessionDidEndPlayback:(SPSession *)aSession
{
    [super sessionDidEndPlayback:aSession];
}

+ (NSSet *)keyPathsForValuesAffectingTrackPositionString
{
    return [NSSet setWithArray:@[@"trackPosition"]];
}

- (NSString *)trackPositionString
{
    if (self.currentTrack == nil)
        return @"";
    int min = self.trackPosition/60;
    int sec = self.trackPosition - (min * 60);
    return [NSString stringWithFormat:@"%02d:%02d", min, sec];
}


@end
