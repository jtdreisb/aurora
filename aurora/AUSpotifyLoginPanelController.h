//
//  AULoginViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 4/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface AUSpotifyLoginPanelController : NSWindowController <NSControlTextEditingDelegate>
{
    IBOutlet NSTextField *_usernameField;
    IBOutlet NSTextField *_passwordField;
    IBOutlet NSButton *_signInButton;
    IBOutlet NSProgressIndicator *_progressIndicator;
}

- (IBAction)signIn:(id)sender;
- (void)save;
- (void)reset;

@end
