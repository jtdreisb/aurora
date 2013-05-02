//
//  AULoginViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 4/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUSpotifyLoginPanelController.h"

@implementation AUSpotifyLoginPanelController

- (BOOL)hasValidValues
{
    return (_usernameField.stringValue.length > 0) && (_passwordField.stringValue.length > 0);
}

- (void)windowDidLoad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"spotify_username"] ?: @"";
    NSString *credential = [defaults objectForKey:@"spotify_credential"] ?: @"";
    
    if ([self hasValidValues]) {
        [[SPSession sharedSession] attemptLoginWithUserName:username existingCredential:credential];
    }
    else {
        if ([username length] > 0) {
            _usernameField.stringValue = username;
            [_passwordField becomeFirstResponder];
        }
    }
}

#pragma mark - Actions
- (IBAction)signIn:(id)sender
{
    if ([self hasValidValues]) {
        [_progressIndicator setHidden:NO];
        [_progressIndicator startAnimation:self];
        [[SPSession sharedSession] attemptLoginWithUserName:_usernameField.stringValue password:_passwordField.stringValue];
    }
    else {
        NSBeep();
    }
}

- (IBAction)cancelSheet:(id)sender
{
    [NSApp endSheet:self.window returnCode:NSCancelButton];
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

- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_usernameField.stringValue forKey:@"spotify_username"];
}

- (void)reset
{
    [_usernameField setEnabled:YES];
    [_passwordField setEnabled:YES];
    [_progressIndicator setHidden:YES];
    [_progressIndicator stopAnimation:self];
    [self shake];
}

#pragma mark - NSControlTextEditingDelegate

//- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
//{
//    if (control == _passwordField) {
//            [_signInButton setEnabled:[self hasValidValues]];
//    }
//    return YES;
//}
//- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
//{
//
//    return YES;
//}

@end
