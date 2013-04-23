//
//  AULoginViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 4/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SNRMusicKitMac/SMKSpotifyContentSource.h>

@interface AULoginViewController : NSViewController <BFViewController, SPSessionDelegate, NSControlTextEditingDelegate>

@property (weak) IBOutlet NSTextField *usernameField;
@property (weak) IBOutlet NSTextField *passwordField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSButton *signInButton;


- (IBAction)signIn:(id)sender;

@end
