//
//  AUSpotifyViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface AUSpotifyViewController : NSViewController <SPSessionDelegate, SPPlaybackManagerDelegate>

@property (strong) IBOutlet NSArrayController *lightsArrayController;
@property (weak) IBOutlet NSImageView *albumImageView;
@property (weak) IBOutlet NSTextField *artistNameLabel;
@property (weak) IBOutlet NSTextField *trackNameLabel;
@property (weak) IBOutlet NSView *colorView;
@property (weak) IBOutlet NSButton *playPauseButton;

@property (strong) IBOutlet NSArrayController *playlistArrayController;
@property (strong) IBOutlet NSArrayController *trackArrayController;


@property (strong) SPPlaybackManager *playbackManager;


@end
