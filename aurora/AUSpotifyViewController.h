//
//  AUSpotifyViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SNRMusicKitMac/SMKSpotifyContentSource.h>

@interface AUSpotifyViewController : NSViewController <SPSessionDelegate>

@property (strong) IBOutlet NSArrayController *lightsArrayController;
@property (weak) IBOutlet NSImageView *albumImageView;
@property (weak) IBOutlet NSTextField *artistNameLabel;
@property (weak) IBOutlet NSTextField *trackNameLabel;
@property (weak) IBOutlet NSView *colorView;
@property (weak) IBOutlet NSButton *playPauseButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contentSource:(SMKSpotifyContentSource *)source;

@end
