//
//  SPAppDelegate.m
//  aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUAppDelegate.h"

NSString *const kHueUsernamePrefKey = @"HueAPIUsernamePrefKey";

@implementation AUAppDelegate
{
    DPHueDiscover *_dhd;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:kHueUsernamePrefKey] == nil) {
        NSString *username = [DPHueBridge generateUsername];
        [prefs setObject:username forKey:kHueUsernamePrefKey];
        [prefs synchronize];
    }
    [self startDiscovery:self];
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}
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

// Try to connect to any know hues
// if that doesn't work bring up a dialog.
// Otherwise open up all of the available hues in their own windows

- (IBAction)startDiscovery:(id)sender
{
    if (_dhd == nil)
        _dhd = [[DPHueDiscover alloc] initWithDelegate:self];
    // Discover forever
    [_dhd discoverForDuration:0 withCompletion:^(NSMutableString *log) {
        NSLog(@"Discovery has timed out:\n%@", log);
    }];
}

- (IBAction)cancelDiscovery:(id)sender
{
    [_dhd stopDiscovery];
    _dhd = nil;
}

#pragma mark - DPHueDiscover delegate

- (void)foundHueAt:(NSString *)host discoveryLog:(NSMutableString *)log {
    NSLog(@"%s: %@\n%@", __PRETTY_FUNCTION__, host, log);
    DPHueBridge *someHue = [[DPHueBridge alloc] initWithHueHost:host username:[[NSUserDefaults standardUserDefaults] objectForKey:kHueUsernamePrefKey]];
    [someHue readWithCompletion:^(DPHueBridge *hue, NSError *err) {
//        NSLog(@"%@", hue.name);
        DPHueLight *light = hue.lights[0];
        NSLog(@"light: %@", light);
        light.brightness = @0;
        light.name = @"Floor Lamp";
        [light write];
        NSLog(@"after: %@", light);
//        hue.name = @"bar";
        
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createUsernameAt:) userInfo:host repeats:YES];
    }];
}

@end
