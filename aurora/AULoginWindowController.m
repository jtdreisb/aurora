//
//  AULoginViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 4/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AULoginWindowController.h"
#import "AUWindowController.h"


@implementation AULoginWindowController

- (BOOL)hasValidValues
{
    return (self.usernameField.stringValue.length > 0) && (self.passwordField.stringValue.length > 0);
}

- (void)windowDidLoad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"spotify_username"] ?: @"";
    NSString *credential = [defaults objectForKey:@"spotify_credential"] ?: @"";
    
    if ([self hasValidValues]) {
        [[SPSession sharedSession] attemptLoginWithUserName:username existingCredential:credential];
        [self.progressIndicator setHidden:NO];
        [self.progressIndicator startAnimation:self];
    }
    else {
        [self.signInButton setEnabled:NO];
        [self.progressIndicator setHidden:YES];
    }
}

#pragma mark - Actions
- (IBAction)signIn:(id)sender
{
    if ([self hasValidValues]) {
        [self.usernameField setEnabled:NO];
        [self.passwordField setEnabled:NO];
        [self.signInButton setEnabled:NO];
        [self.progressIndicator setHidden:NO];
        [self.progressIndicator startAnimation:self];
        
        [[SPSession sharedSession] attemptLoginWithUserName:self.usernameField.stringValue password:self.passwordField.stringValue];
    }
    else {
        NSBeep();
    }
}

- (void)shake
{
    //Gets the window rect
    NSRect rect = [self.window frame];
    //Shake offset amount
    int amount = -10;
    //Shake the window 5 times
    for(int i = 0; i < 5; i++){
        //Changes the frame origin
        [self.window setFrameOrigin:NSMakePoint((rect.origin.x + amount), rect.origin.y)];
        //Pause the thread for 0.04 seconds
        usleep((useconds_t)40000);
        //Inverts the offset amount
        amount *= -1;
    }
    //Restore the window’s original position
    [self.window setFrame:rect display:NO];
}

- (void)failReset
{
    [self.progressIndicator stopAnimation:self];
    [self.progressIndicator setHidden:YES];
    [self.usernameField setEnabled:YES];
    [self.passwordField setEnabled:YES];
    [self shake];
}

#pragma mark - NSControlTextEditingDelegate
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    [self.signInButton setEnabled:[self hasValidValues]];
    return YES;
}

@end
