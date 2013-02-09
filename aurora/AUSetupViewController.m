//
//  AUSetupViewController.m
//  aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUSetupViewController.h"
#import <DPHue/DPHueBridge.h>
#import "AULightsViewController.h"

NSString *const kHueAPIUsernamePrefKey = @"HueAPIUsernamePrefKey";

@interface AUSetupViewController ()

@property (nonatomic, strong) DPHueDiscover *dhd;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AUSetupViewController

- (void)awakeFromNib
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:kHueAPIUsernamePrefKey] == nil) {
        NSString *username = [DPHueBridge generateUsername];
        [prefs setObject:username forKey:kHueAPIUsernamePrefKey];
        [prefs synchronize];
    }
}

- (IBAction)startDiscovery:(id)sender
{
    self.dhd = [[DPHueDiscover alloc] initWithDelegate:self];
    [self.dhd discoverForDuration:30 withCompletion:^(NSMutableString *log) {
        NSLog(@"Discovery has timed out:\n%@", log);
    }];
    NSLog(@"%@", @"Searching for Hue...");
}

- (IBAction)cancelDiscovery:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.dhd stopDiscovery];
    self.dhd = nil;
}

- (void)createUsernameAt:(NSTimer *)timer {
    NSString *host = timer.userInfo;
    NSLog(@"Attempting to create username at %@", host);
    DPHueBridge *someHue = [[DPHueBridge alloc] initWithHueHost:host username:[[NSUserDefaults standardUserDefaults] objectForKey:kHueAPIUsernamePrefKey]];
    [someHue readWithCompletion:^(DPHueBridge *hue, NSError *err) {
        if (hue.authenticated) {
            NSLog(@"%@: Successfully authenticated\n", [NSDate date]);
            [self.timer invalidate];
            NSLog(@"Found Hue at %@, named '%@'!", hue.host, hue.name);
            [self.dhd stopDiscovery];
            
            self.lightsViewController.hue = hue;
            self.lightsViewController.view.frame = self.view.frame;
            [self.view.superview addSubview:self.lightsViewController.view];
            [self.view removeFromSuperview];

            
        } else {
            NSLog(@"%@: Authentication failed, will try to create username\n", [NSDate date]);
            [someHue registerUsername];
            NSLog(@"%@", @"Press Button On Hue!");
        }
    }];
}

#pragma mark - DPHueDiscover delegate

- (void)foundHueAt:(NSString *)host discoveryLog:(NSMutableString *)log {
    NSLog(@"%s: %@\n%@", __PRETTY_FUNCTION__, host, log);
    DPHueBridge *someHue = [[DPHueBridge alloc] initWithHueHost:host username:[[NSUserDefaults standardUserDefaults] objectForKey:kHueAPIUsernamePrefKey]];
    [someHue readWithCompletion:^(DPHueBridge *hue, NSError *err) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createUsernameAt:) userInfo:host repeats:YES];
    }];
}

@end
