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
#import "AUEffectTestViewController.h"

@implementation AUAppDelegate
{
    AUSpotifyLoginPanelController *_spotifyLoginPanelController;
    BFNavigationController *_navController;
    AUEffectTestViewController *_effectTestViewController;
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    NSError *error = nil;
	[SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size]
											   userAgent:@"com.jasondreisbach.aurora"
										   loadingPolicy:SPAsyncLoadingManual
												   error:&error];
	if (error != nil) {
		NSLog(@"CocoaLibSpotify init failed: %@", error);
		abort();
	}
    
	[[SPSession sharedSession] setDelegate:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    
    NSInteger musicTabIndex = [self.tabView indexOfTabViewItemWithIdentifier:@"music"];
    NSTabViewItem *musicTabItem = [self.tabView tabViewItemAtIndex:musicTabIndex];
    _navController = [[BFNavigationController alloc] initWithFrame:[musicTabItem.view frame] rootViewController:nil];
    musicTabItem.view = _navController.view;
    
    
    NSInteger hueTabIndex = [self.tabView indexOfTabViewItemWithIdentifier:@"hue"];
    NSTabViewItem *hueTabItem = [self.tabView tabViewItemAtIndex:hueTabIndex];
    _effectTestViewController = [[AUEffectTestViewController alloc] initWithNibName:@"AUEffectTestView" bundle:nil];
    
    hueTabItem.view = _effectTestViewController.view;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"spotify_username"];
    NSString *credential =  [defaults objectForKey:@"spotify_credential"];
    if ([credential length] > 0) {
        [[SPSession sharedSession] attemptLoginWithUserName:username existingCredential:credential];
    }
    else {
        [self showLoginSheet:self];
    }
}

- (IBAction)showLoginSheet:(id)sender
{
    // Log out if necessary
    if (_spotifyLoginPanelController == nil) {
        _spotifyLoginPanelController = [[AUSpotifyLoginPanelController alloc] initWithWindowNibName:@"AUSpotifyLoginPanel"];
    }
    [_spotifyLoginPanelController reset];
    
    if([_spotifyLoginPanelController.window isModalPanel] == NO) {
        [NSApp beginSheet:_spotifyLoginPanelController.window
           modalForWindow:self.window
            modalDelegate:self
           didEndSelector:@selector(loginSheetDidEnd:returnCode:contextInfo:)
              contextInfo:nil];
    }
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
    }
}

#pragma mark -
#pragma mark SPSession Delegates

- (void)sessionDidLoginSuccessfully:(SPSession *)aSession
{
    if ([_spotifyLoginPanelController.window isModalPanel])
        [NSApp endSheet:_spotifyLoginPanelController.window returnCode:NSOKButton];

    AUSpotifyViewController *spotifyViewController = [[AUSpotifyViewController alloc] initWithNibName:@"AUSpotifyView" bundle:nil];
    [_navController pushViewController:spotifyViewController animated:NO];    
}

- (void)session:(SPSession *)aSession didGenerateLoginCredentials:(NSString *)credential forUserName:(NSString *)userName
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, userName);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:@"spotify_username"];
    [defaults setObject:credential forKey:@"spotify_credential"];
    [defaults synchronize];
}

- (void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error
{
	// Invoked by SPSession after a failed login.
    NSLog(@"%@", error);
    [_spotifyLoginPanelController reset];
    
}

- (void)sessionDidLogOut:(SPSession *)aSession
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
}

//- (void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage
//{
//    NSLog(@"%s: %@", __PRETTY_FUNCTION__, aMessage);
//}

- (void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage; {
    
	[[NSAlert alertWithMessageText:aMessage
					 defaultButton:@"OK"
				   alternateButton:@""
					   otherButton:@""
		 informativeTextWithFormat:@"This message was sent to you from the Spotify service."] runModal];
}


- (NSArray *)tracksFromPlaylistItems:(NSArray *)items {
	
	NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:items.count];
	
	for (SPPlaylistItem *anItem in items) {
		if (anItem.itemClass == [SPTrack class]) {
			[tracks addObject:anItem.item];
		}
	}
	
	return [NSArray arrayWithArray:tracks];
}



@end
