//
//  SPAppDelegate.m
//  aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUAppDelegate.h"
#import "AULoginWindowController.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@implementation AUAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.loginWindowController = [[AULoginWindowController alloc] initWithWindowNibName:@"AULoginWindow"];
    [self.loginWindowController showWindow:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	if ([SPSession sharedSession].connectionState == SP_CONNECTION_STATE_LOGGED_OUT ||
		[SPSession sharedSession].connectionState == SP_CONNECTION_STATE_UNDEFINED)
		return NSTerminateNow;
	
	[[SPSession sharedSession] logout:^{
		[[NSApplication sharedApplication] replyToApplicationShouldTerminate:YES];
	}];
	return NSTerminateLater;
}

// ********************************************************************************
// App Delegate Callbacks
// ********************************************************************************

//- (void)applicationWillFinishLaunching:(NSNotification *)notification;
//- (void)applicationDidFinishLaunching:(NSNotification *)notification;
//- (void)applicationWillHide:(NSNotification *)notification;
//- (void)applicationDidHide:(NSNotification *)notification;
//- (void)applicationWillUnhide:(NSNotification *)notification;
//- (void)applicationDidUnhide:(NSNotification *)notification;
//- (void)applicationWillBecomeActive:(NSNotification *)notification;
//- (void)applicationDidBecomeActive:(NSNotification *)notification;
//- (void)applicationWillResignActive:(NSNotification *)notification;
//- (void)applicationDidResignActive:(NSNotification *)notification;
//- (void)applicationWillUpdate:(NSNotification *)notification;
//- (void)applicationDidUpdate:(NSNotification *)notification;
//- (void)applicationWillTerminate:(NSNotification *)notification;
//- (void)applicationDidChangeScreenParameters:(NSNotification *)notification;

@end
