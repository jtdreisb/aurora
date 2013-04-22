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
    
    
//    DBG_DPHueBridge *bridge = [[DBG_DPHueBridge alloc] initWithHueHost:@"localhost" username:@"33bf7ba02ee74a8f1e9397f03b09fa7f"];
//    
//    [bridge readWithCompletion:^(DPHueBridge *hue, NSError *err) {
//        [self.lightArrayController addObjects:bridge.lights];
//    }];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:kHueUsernamePrefKey] == nil) {
        NSString *username = [DPHueBridge generateUsername];
        [prefs setObject:username forKey:kHueUsernamePrefKey];
        [prefs synchronize];
    }
    [self startDiscovery:self];
}

- (void)loadViewControllers
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSTabViewItem *effectsItem = [[NSTabViewItem alloc] initWithIdentifier:@"effects"];
        [effectsItem setLabel:@"Effects"];
        [effectsItem setView:self.effectTestViewController.view];
        [self.tabView addTabViewItem:effectsItem];
        
        NSTabViewItem *spotifyItem = [[NSTabViewItem alloc] initWithIdentifier:@"spotify"];
        [spotifyItem setLabel:@"Spotify"];
        [spotifyItem setView:self.spotifyViewController.view];
        [self.tabView addTabViewItem:spotifyItem];
        
    });
}

- (void)showViewController:(NSViewController *)viewController
{
    NSRect contentRect = [self.window.contentView frame];
    viewController.view.frame = contentRect;
    self.window.contentView = viewController.view;
}

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
