//
//  AUAppDelegate.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/1/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUAppDelegate.h"
#import "AUSpotifyLoginPanelController.h"
#import "BFNavigationController.h"
#import "AUSpotifyViewController.h"

@implementation AUAppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    NSError *error = nil;
	[SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size]
											   userAgent:@"com.jasondreisbach.aurora"
										   loadingPolicy:SPAsyncLoadingImmediate
												   error:&error];
	if (error != nil) {
		NSLog(@"CocoaLibSpotify init failed: %@", error);
		abort();
	}
    
	[[SPSession sharedSession] setDelegate:self];
	self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
	self.playbackManager.delegate = self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    
    _navController = [[BFNavigationController alloc] initWithFrame:[self.window.contentView frame] rootViewController:nil];
    
    self.window.contentView = _navController.view;
    
    [self showLoginSheet:self];
}

- (IBAction)showLoginSheet:(id)sender
{
    // Log out if necessary
    if (_spotifyLoginPanelController == nil) {
        _spotifyLoginPanelController = [[AUSpotifyLoginPanelController alloc] initWithWindowNibName:@"AUSpotifyLoginPanel"];
    }
    [NSApp beginSheet:_spotifyLoginPanelController.window
       modalForWindow:self.window
        modalDelegate:self
       didEndSelector:@selector(loginSheetDidEnd:returnCode:contextInfo:)
          contextInfo:nil];
}

- (void)loginSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode == NSCancelButton) {
        [NSApp stopModal];
        [NSApp terminate:self];
    }
    else if (returnCode == NSOKButton) {
        [_spotifyLoginPanelController save];
        [_spotifyLoginPanelController.window orderOut:self];
        _spotifyLoginPanelController = nil;
        
        AUSpotifyViewController *spotifyViewController = [[AUSpotifyViewController alloc] initWithNibName:@"AUSpotifyView" bundle:nil];
        [_navController pushViewController:spotifyViewController animated:NO];
    }
}

#pragma mark -
#pragma mark SPSession Delegates

- (void)sessionDidLoginSuccessfully:(SPSession *)aSession
{
    NSLog(@"did login");
    [NSApp endSheet:_spotifyLoginPanelController.window returnCode:NSOKButton];

}

- (void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error
{
	// Invoked by SPSession after a failed login.
    [NSApp stopModal];
    NSLog(@"%@", error);
    [_spotifyLoginPanelController reset];
    
}

-(void)sessionDidLogOut:(SPSession *)aSession; {}
-(void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error; {}
-(void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage; {}
-(void)sessionDidChangeMetadata:(SPSession *)aSession; {}

-(void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage; {
    
	[[NSAlert alertWithMessageText:aMessage
					 defaultButton:@"OK"
				   alternateButton:@""
					   otherButton:@""
		 informativeTextWithFormat:@"This message was sent to you from the Spotify service."] runModal];
}


-(void)playbackManagerWillStartPlayingAudio:(SPPlaybackManager *)aPlaybackManager
{
    
    
    
}

-(NSArray *)tracksFromPlaylistItems:(NSArray *)items {
	
	NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:items.count];
	
	for (SPPlaylistItem *anItem in items) {
		if (anItem.itemClass == [SPTrack class]) {
			[tracks addObject:anItem.item];
		}
	}
	
	return [NSArray arrayWithArray:tracks];
}

- (void)startPlaybackOfTrack:(SPTrack *)aTrack {
	
	[SPAsyncLoading waitUntilLoaded:aTrack timeout:5.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
		[self.playbackManager playTrack:aTrack callback:^(NSError *error) {
			if (error) [self.window presentError:error];
		}];
	}];
}


-(void)sessionDidEndPlayback:(id <SPSessionPlaybackProvider>)aSession
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}



@end
