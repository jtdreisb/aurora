//
//  AUWindowController.m
//  Aurora
//
//  Created by Jason Dreisbach on 2/8/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUWindowController.h"
#import "AUEffectTestViewController.h"
#import "DBG_DPHueBridge.h"
#import "AUSpotifyViewController.h"

NSString *const kHueUsernamePrefKey = @"HueAPIUsernamePrefKey";

@interface AUWindowController ()
@end

@implementation AUWindowController
{
    DPHueDiscover *_dhd;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self loadViewControllers];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:kHueUsernamePrefKey] == nil) {
        NSString *username = [DPHueBridge generateUsername];
        [prefs setObject:username forKey:kHueUsernamePrefKey];
        [prefs synchronize];
    }
//    [self startDiscovery:self];
}

- (void)loadViewControllers
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _navController = [[BFNavigationController alloc] initWithFrame:NSMakeRect(0, 0, self.window.frame.size.width, self.window.frame.size.height) rootViewController:self.spotifyViewController];
        NSTabViewItem *appItem = [[NSTabViewItem alloc] initWithIdentifier:@"App"];
        [appItem setLabel:@"App"];
        
        [appItem setView:_navController.view];
        [self.tabView addTabViewItem:appItem];
        
        NSTabViewItem *effectsItem = [[NSTabViewItem alloc] initWithIdentifier:@"effects"];
        [effectsItem setLabel:@"Effects"];
        [effectsItem setView:self.effectTestViewController.view];
        [self.tabView addTabViewItem:effectsItem];
        
        [self.tabView selectFirstTabViewItem:self];
    });
}

//- (void)showViewController:(NSViewController *)viewController
//{
//    NSRect contentRect = [self.window.contentView frame];
//    viewController.view.frame = contentRect;
//    self.window.contentView = viewController.view;
//}

#pragma mark - Actions


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

- (IBAction)logoutOfSpotify:(id)sender
{
    [[SPSession sharedSession] logout:^{
        NSLog(@"Successful Logout");
        [NSApp terminate:self];
    }];
}


#pragma mark - DPHueDiscover delegate

- (void)foundHueAt:(NSString *)host discoveryLog:(NSMutableString *)log {
    DPHueBridge *someHue = [[DPHueBridge alloc] initWithHueHost:host username:[[NSUserDefaults standardUserDefaults] objectForKey:kHueUsernamePrefKey]];
    [someHue readWithCompletion:^(DPHueBridge *hue, NSError *err) {
        if (err == nil) {
            [(AUEffectTestViewController *)self.effectTestViewController addLights:someHue.lights];
        }
    }];
}

@end
