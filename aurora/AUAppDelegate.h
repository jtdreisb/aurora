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

@interface AUAppDelegate : NSObject <NSApplicationDelegate, SPSessionDelegate, SPSessionPlaybackDelegate, SPPlaybackManagerDelegate>
{
    AUSpotifyLoginPanelController *_spotifyLoginPanelController;
    BFNavigationController *_navController;
}

@property (assign) IBOutlet NSWindow *window;
@property (strong) SPPlaybackManager *playbackManager;


- (IBAction)showLoginSheet:(id)sender;
@end
