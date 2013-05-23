//
//  AUAppDelegate.h
//  Aurora
//
//  Created by Jason Dreisbach on 5/1/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <DPHue.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import "BFNavigationController.h"

@interface AUAppDelegate : NSObject <NSApplicationDelegate, SPSessionDelegate, DPHueDelegate, BFNavigationControllerDelegate>

@property (strong) IBOutlet NSObjectController *playbackObjectController;

@property NSInteger tabSelectionIndex;

- (IBAction)showLoginSheet:(id)sender;

- (IBAction)playPause:(id)sender;
- (IBAction)nextTrack:(id)sender;
- (IBAction)previousTrack:(id)sender;

@end
