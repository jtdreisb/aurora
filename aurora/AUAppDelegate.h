//
//  AUAppDelegate.h
//  Aurora
//
//  Created by Jason Dreisbach on 5/1/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <CocoaLibSpotify/CocoaLibSpotify.h>

#import "appkey.h"

@class AUSpotifyLoginPanelController;
@class BFNavigationController;

@interface AUAppDelegate : NSObject <NSApplicationDelegate, SPSessionDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTabView *tabView;
@property (strong) IBOutlet NSObjectController *playbackObjectController;

@property NSInteger tabSelectionIndex;


- (IBAction)showLoginSheet:(id)sender;

@end
