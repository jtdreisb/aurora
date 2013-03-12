//
//  AUWindowController.m
//  Aurora
//
//  Created by Jason Dreisbach on 2/8/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUWindowController.h"
#import "AUWindow.h"

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
    
    [(AUWindow *)self.window collapse];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:kHueUsernamePrefKey] == nil) {
        NSString *username = [DPHueBridge generateUsername];
        [prefs setObject:username forKey:kHueUsernamePrefKey];
        [prefs synchronize];
    }
    [self startDiscovery:self];
}


#pragma mark - Actions

- (IBAction)expand:(id)sender
{
    [self.window setContentView:self.performanceViewController.view];
    [(AUWindow *)self.window expand];

}

- (IBAction)collapse:(id)sender
{
    [(AUWindow *)self.window collapse];
}

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
    //    NSLog(@"%s: %@\n%@", __PRETTY_FUNCTION__, host, log);
    DPHueBridge *someHue = [[DPHueBridge alloc] initWithHueHost:host username:[[NSUserDefaults standardUserDefaults] objectForKey:kHueUsernamePrefKey]];
    
    [self.hueBridgeArray addObject:someHue];
    
    //    [someHue readWithCompletion:^(DPHueBridge *hue, NSError *err) {
    //        //        NSLog(@"%@", hue.name);
    //
    //
    //        DPHueLight *light = hue.lights[0];
    //        NSLog(@"light: %@", light);
    //        light.brightness = @255;
    //        light.name = @"Floor Lamp";
    //        [light write];
    //        NSLog(@"after: %@", light);
    //
    //        //        hue.name = @"bar";
    //
    //        //        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createUsernameAt:) userInfo:host repeats:YES];
    //    }];
}

@end
