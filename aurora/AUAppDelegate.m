//
//  SPAppDelegate.m
//  aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUAppDelegate.h"
#import "AUWindowController.h"



@implementation AUAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    self.windowController = [[AUWindowController alloc] initWithWindowNibName:@"AUWindowController"];
    [self.windowController showWindow:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
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
