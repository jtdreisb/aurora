//
//  AUPlaybackCoordinator.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUPlaybackCoordinator.h"
#import "SPPlaylist+AUAdditions.h"

@interface AUPlaybackCoordinator ()
@end

@implementation AUPlaybackCoordinator
{
    dispatch_queue_t _lightEffectQueue;
    NSInteger _currentTrackIndex;
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
    if (self.currentPlaylist != nil) {
        [self nextTrack];
        self.isPlaying = YES;
    }
    else {
        [super sessionDidEndPlayback:aSession];
    }
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

- (void)playTrack:(SPTrack *)aTrack callback:(SPErrorableOperationCallback)block
{
    if (self.currentPlaylist != nil) {
        NSUInteger trackIndex = [self.currentPlaylist.tracks indexOfObject:aTrack];
        if (trackIndex != NSNotFound) {
            _currentTrackIndex = trackIndex;
        }
        else {
            self.currentPlaylist = nil;
        }
    }
    [super playTrack:aTrack callback:block];
}


- (void)setCurrentPlaylist:(SPPlaylist *)currentPlaylist
{
    if (_currentPlaylist != currentPlaylist) {
        _currentPlaylist = currentPlaylist;
        [self playTrack:self.currentPlaylist.tracks[0] callback:^(NSError *error) {
            self.isPlaying = NO;
        }];
    }
}

- (void)previousTrack
{
    if (self.currentPlaylist != nil) {
        NSInteger nextTrackIndex;
        if (_currentTrackIndex == 0) {
            nextTrackIndex = self.currentPlaylist.tracks.count - 1;
        }
        else {
            nextTrackIndex = _currentTrackIndex - 1;
        }
        BOOL shouldPlay = self.isPlaying;
        [self playTrack:self.currentPlaylist.tracks[nextTrackIndex] callback:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%s:playTrack:%@", __PRETTY_FUNCTION__, error);
            }
            self.isPlaying = shouldPlay;
        }];
    }
}

- (void)nextTrack
{
    if (self.currentPlaylist != nil) {
        NSUInteger nextTrackIndex = _currentTrackIndex + 1;
        if (nextTrackIndex >= self.currentPlaylist.tracks.count) {
            nextTrackIndex = 0;
        }
        BOOL shouldPlay = self.isPlaying;
        [self playTrack:self.currentPlaylist.tracks[nextTrackIndex] callback:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%s:playTrack:%@", __PRETTY_FUNCTION__, error);
            }
            self.isPlaying = shouldPlay;
        }];
    }
}

@end
