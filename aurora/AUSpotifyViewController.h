//
//  AUSpotifyViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DPHueBridge;
@interface AUSpotifyViewController : NSViewController

@property (strong) DPHueBridge *hue;
@property (weak) IBOutlet NSImageView *albumImageView;
@property (weak) IBOutlet NSTextField *artistNameLabel;
@property (weak) IBOutlet NSTextField *trackNameLabel;
@property (weak) IBOutlet NSView *colorView;
- (void)showView;

@end
