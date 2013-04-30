//
//  SPAppDelegate.m
//  aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUAppDelegate.h"
#import "AULoginWindowController.h"
#import "AUWindowController.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@implementation AUAppDelegate
- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    NSError *error = nil;
	[SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size]
											   userAgent:@"com.jason.test"
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
    [[SPSession sharedSession] attemptLoginWithUserName:@"jtdreisb" password:@"scoutdaisy"];
}


#pragma mark -
#pragma mark SPSession Delegates

-(void)sessionDidLoginSuccessfully:(SPSession *)aSession; {
	
	// Invoked by SPSession after a successful login.
	
	
    //	self.regionTopList = [SPToplist toplistForLocale:aSession.locale
    //										   inSession:aSession];
    //	self.userTopList = [SPToplist toplistForCurrentUserInSession:aSession];
	NSLog(@"didlogin");
    [SPAsyncLoading waitUntilLoaded:[SPSession sharedSession] timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
        NSLog(@"sessionloaded");
        [SPAsyncLoading waitUntilLoaded:[SPSession sharedSession].starredPlaylist timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            NSLog(@"playlistloaded");
            NSArray *tracks = [self tracksFromPlaylistItems:[SPSession sharedSession].starredPlaylist.items];
            [self startPlaybackOfTrack:tracks[0]];
        }];
        
    }];
}

-(void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error; {
    
	// Invoked by SPSession after a failed login.
	NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);

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
			if (error) {
                NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
            }
		}];
	}];
}


-(void)sessionDidEndPlayback:(id <SPSessionPlaybackProvider>)aSession
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
//- (void)applicationWillFinishLaunching:(NSNotification *)notification
//{
//    NSError *error = nil;
//	[SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size]
//											   userAgent:@"com.spotify.GuessTheIntro"
//										   loadingPolicy:SPAsyncLoadingImmediate
//												   error:&error];
//	if (error != nil) {
//		NSLog(@"CocoaLibSpotify init failed: %@", error);
//		abort();
//	}
//    
//	[[SPSession sharedSession] setDelegate:self];
////	self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
////	self.playbackManager.delegate = self;
//    
//}
//
//- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
//{
//    self.loginWindowController = [[AULoginWindowController alloc] initWithWindowNibName:@"AULoginWindow"];
//    [self.loginWindowController showWindow:self];
//    [self.loginWindowController.window center];
//}
//
//- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
//{
//    return YES;
//}
//
//- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
//	if ([SPSession sharedSession].connectionState == SP_CONNECTION_STATE_LOGGED_OUT ||
//		[SPSession sharedSession].connectionState == SP_CONNECTION_STATE_UNDEFINED)
//		return NSTerminateNow;
//	
//	[[SPSession sharedSession] logout:^{
//		[[NSApplication sharedApplication] replyToApplicationShouldTerminate:YES];
//	}];
//	return NSTerminateLater;
//}
//
//// ********************************************************************************
//// App Delegate Callbacks
//// ********************************************************************************
//
////- (void)applicationWillFinishLaunching:(NSNotification *)notification;
////- (void)applicationDidFinishLaunching:(NSNotification *)notification;
////- (void)applicationWillHide:(NSNotification *)notification;
////- (void)applicationDidHide:(NSNotification *)notification;
////- (void)applicationWillUnhide:(NSNotification *)notification;
////- (void)applicationDidUnhide:(NSNotification *)notification;
////- (void)applicationWillBecomeActive:(NSNotification *)notification;
////- (void)applicationDidBecomeActive:(NSNotification *)notification;
////- (void)applicationWillResignActive:(NSNotification *)notification;
////- (void)applicationDidResignActive:(NSNotification *)notification;
////- (void)applicationWillUpdate:(NSNotification *)notification;
////- (void)applicationDidUpdate:(NSNotification *)notification;
////- (void)applicationWillTerminate:(NSNotification *)notification;
////- (void)applicationDidChangeScreenParameters:(NSNotification *)notification;
//
//#pragma mark -
//#pragma mark SPSession Delegates
//
//-(void)sessionDidLoginSuccessfully:(SPSession *)aSession;
//{
//    [self.loginWindowController close];
//    self.loginWindowController = nil;
//    
//    [SPAsyncLoading waitUntilLoaded:[SPSession sharedSession] timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
//        NSLog(@"%@", loadedItems);
//    }];
//
//    self.windowController = [[AUWindowController alloc] initWithWindowNibName:@"AUWindow"];
//    [self.windowController showWindow:self];
//    [self.windowController.window center];
//	
//}
//
//-(void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error; {
//    
//	// Invoked by SPSession after a failed login.
//    
//    [(AULoginWindowController *)self.loginWindowController failReset];
//	
//    [NSApp presentError:error
//         modalForWindow:self.loginWindowController.window
//               delegate:nil
//     didPresentSelector:nil
//            contextInfo:nil];
//}
//
//-(void)sessionDidLogOut:(SPSession *)aSession; {}
//-(void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error; {}
//-(void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage; {}
//-(void)sessionDidChangeMetadata:(SPSession *)aSession; {}
//
//-(void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage; {
//    
//	[[NSAlert alertWithMessageText:aMessage
//					 defaultButton:@"OK"
//				   alternateButton:@""
//					   otherButton:@""
//		 informativeTextWithFormat:@"This message was sent to you from the Spotify service."] runModal];
//}


@end
