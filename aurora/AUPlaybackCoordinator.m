//
//  AUPlaybackCoordinator.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUPlaybackCoordinator.h"
#import "SPPlaylist+AUAdditions.h"
#import "SPTrack+AUAdditions.h"
#import "AUTimeline.h"
#import "AUTimelineChannel.h"
#import "AUEffect.h"
#import <sys/time.h>
#import <DPHue.h>

#define kEffectQueueLength 0.3;

@interface AUPlaybackCoordinator ()
@end

@implementation AUPlaybackCoordinator
{
    dispatch_queue_t _lightEffectQueue;
    NSInteger _currentTrackIndex;
    NSTimeInterval _lightQueueIndex;
    dispatch_time_t _startTime;
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
        _lightEffectQueue = dispatch_queue_create("com.apple.aurora.lights.q", DISPATCH_QUEUE_SERIAL);
        [self addObserver:self forKeyPath:@"isPlaying" options:0 context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"isPlaying"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"isPlaying"]) {
        _lightQueueIndex = self.trackPosition;
        if (self.isPlaying == YES) {
            _startTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (-1.0 * self.trackPosition * NSEC_PER_SEC));
            [self queueEffects];
        }
    }
}

- (void)seekToTrackPosition:(NSTimeInterval)newPosition
{
    [super seekToTrackPosition:newPosition];
    _lightQueueIndex = self.trackPosition;
    _startTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (-1.0 * self.trackPosition * NSEC_PER_SEC));
}

- (void)queueEffects
{
    NSArray *allLights = [[DPHue sharedInstance] lights];
    NSArray *channels = self.currentTrack.timeline.channels;
    NSTimeInterval oldTrackIndex = _lightQueueIndex;
    NSTimeInterval newTrackIndex = self.trackPosition + kEffectQueueLength;
    _lightQueueIndex = newTrackIndex;
    for (DPHueLight *light in allLights) {
        if (channels.count >= [light.number integerValue]) {
            AUTimelineChannel *channel = [channels objectAtIndex:[light.number integerValue] - 1];
            NSArray *effects = [channel effectsFrom:oldTrackIndex to:newTrackIndex];
            if (effects.count > 0) {
                for (AUEffect *effect in effects) {
                    NSDictionary *payloads = effect.payloads;
                    for (NSNumber *dispatchTime in payloads.allKeys) {
                        NSDictionary *payload = payloads[dispatchTime];
                        double delayInSeconds = [dispatchTime doubleValue];
                        dispatch_time_t popTime = dispatch_time(_startTime, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, _lightEffectQueue, ^(void){
                            if (self.isPlaying) {
                                [light.state writeChanges:payload];
                            }
                        });
                    }
                }
            }
        }
    }
}

-(void)coreAudioController:(SPCoreAudioController *)controller didOutputAudioOfDuration:(NSTimeInterval)audioDuration
{
    [super coreAudioController:controller didOutputAudioOfDuration:audioDuration];
    [self queueEffects];
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
        if (self.trackPosition > 0.5) {
            [self seekToTrackPosition:0.0];
        }
        else {
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
