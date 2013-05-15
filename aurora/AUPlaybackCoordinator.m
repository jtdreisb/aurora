//
//  AUPlaybackCoordinator.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUPlaybackCoordinator.h"

@interface AUPlaybackCoordinator ()
- (NSArray *)playlistTracks;
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
        NSUInteger trackIndex = [self.playlistTracks indexOfObject:aTrack];
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
        [self playTrack:self.playlistTracks[0] callback:^(NSError *error) {
            self.isPlaying = NO;
        }];
    }
}

- (void)previousTrack
{
    if (self.currentPlaylist != nil) {
        NSInteger nextTrackIndex;
        if (_currentTrackIndex == 0) {
            nextTrackIndex = self.playlistTracks.count - 1;
        }
        else {
            nextTrackIndex = _currentTrackIndex - 1;
        }
        [self playTrack:self.playlistTracks[nextTrackIndex] callback:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%s:playTrack:%@", __PRETTY_FUNCTION__, error);
            }
        }];
    }
}

- (void)nextTrack
{
    if (self.currentPlaylist != nil) {
        NSUInteger nextTrackIndex = _currentTrackIndex + 1;
        if (nextTrackIndex >= self.playlistTracks.count) {
            nextTrackIndex = 0;
        }
        [self playTrack:self.playlistTracks[nextTrackIndex] callback:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%s:playTrack:%@", __PRETTY_FUNCTION__, error);
            }
        }];
    }
}

- (NSArray *)playlistTracks
{
	if (self.currentPlaylist != nil) {
        NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:self.currentPlaylist.items.count];
        for (SPPlaylistItem *anItem in self.currentPlaylist.items) {
            if (anItem.itemClass == [SPTrack class]) {
                [tracks addObject:anItem.item];
            }
        }
        return [NSArray arrayWithArray:tracks];
    }
    return nil;
}

@end
