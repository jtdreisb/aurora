//
//  AULoginViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 4/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface AULoginWindowController : NSWindowController <NSControlTextEditingDelegate>

@property (weak) IBOutlet NSTextField *usernameField;
@property (weak) IBOutlet NSTextField *passwordField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSButton *signInButton;

- (IBAction)signIn:(id)sender;
- (void)failReset;

@end
