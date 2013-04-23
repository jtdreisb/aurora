//
//  AULoginViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 4/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AULoginViewController.h"
#import "AUSpotifyViewController.h"

@implementation AULoginViewController
{
    SMKSpotifyContentSource *_source;
}

- (BOOL)hasValidValues
{
    return (self.usernameField.stringValue.length > 0) && (self.passwordField.stringValue.length > 0);
}

#pragma mark - BFViewController additions

- (void)viewWillAppear: (BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.usernameField.stringValue = [defaults objectForKey:@"spotify_username"] ?: @"";
    self.passwordField.stringValue = [defaults objectForKey:@"spotify_password"] ?: @"";
    if ([self hasValidValues]) {
        [self signIn:self];
    }
    else {
        [self.signInButton setEnabled:NO];
        [self.progressIndicator setHidden:YES];
    }
}

- (void)viewDidAppear: (BOOL)animated
{
    NSLog(@"%@ - viewDidAppear: %i", self, animated);
}

- (void)viewWillDisappear: (BOOL)animated
{
    NSLog(@"%@ - viewWillDisappear: %i", self, animated);
}

- (void)viewDidDisappear: (BOOL)animated
{
    NSLog(@"%@ - viewDidDisappear: %i", self, animated);
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
        
        NSData *key = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spotify" ofType:@"appkey"]];
        _source = [[SMKSpotifyContentSource alloc] initWithApplicationKey:key userAgent:@"com.jasondreisbach.Aurora" loadingPolicy:SPAsyncLoadingImmediate error:nil];
        [_source attemptLoginWithUserName:self.usernameField.stringValue password:self.passwordField.stringValue];
        [_source setDelegate:self];
        [_source setUsingVolumeNormalization:YES];
    }
    else {
        NSBeep();
    }
}

#pragma mark - SPSessionDelegate
-(void)sessionDidLoginSuccessfully:(SPSession *)aSession
{
    [self.progressIndicator stopAnimation:self];
    [self.progressIndicator setHidden:YES];
    
    AUSpotifyViewController *spotifyViewController = [[AUSpotifyViewController alloc] initWithNibName:@"AUSpotifyView" bundle:nil contentSource:_source];
    
    [self pushViewController:spotifyViewController animated:YES];
}

- (void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error
{
    [self.progressIndicator stopAnimation:self];
    [self.progressIndicator setHidden:YES];
    [self.usernameField setEnabled:YES];
    [self.passwordField setEnabled:YES];
    NSLog(@"Failed login: %@ %@", error, [error userInfo]);
}

#pragma mark - NSControlTextEditingDelegate
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    [self.signInButton setEnabled:[self hasValidValues]];
    return YES;
}

@end
