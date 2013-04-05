//
//  AUWindowController.m
//  Aurora
//
//  Created by Jason Dreisbach on 2/8/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUWindowController.h"

NSString *const kHueUsernamePrefKey = @"HueAPIUsernamePrefKey";

@interface AUWindowController ()
@end

@implementation AUWindowController
{
    DPHueDiscover *_dhd;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        _hueBridgeArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self showViewController:self.effectTestViewController];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:kHueUsernamePrefKey] == nil) {
        NSString *username = [DPHueBridge generateUsername];
        [prefs setObject:username forKey:kHueUsernamePrefKey];
        [prefs synchronize];
    }
    [self startDiscovery:self];
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
            [self.hueBridgeArray addObject:someHue];
        }
    }];
}

@end
