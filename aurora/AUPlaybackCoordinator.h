//
//  AUPlaybackCoordinator.h
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface AUPlaybackCoordinator : SPPlaybackManager

+ (id)sharedInstance;
+ (id)initializeSharedInstance;

@property (nonatomic, strong) SPPlaylist *currentPlaylist;

- (void)previousTrack;
- (void)nextTrack;

@property (readonly) NSString *trackPositionString;

@end
