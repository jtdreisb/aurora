//
//  AUAppDelegate.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/1/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUAppDelegate.h"
#import "AUSpotifyLoginPanelController.h"
#import "BFNavigationController.h"
#import "AUSpotifyViewController.h"
#import "AUEffectTestViewController.h"
#import "AUPlaybackCoordinator.h"

#import "AUStrobe.h"


@implementation AUAppDelegate
{
    AUSpotifyLoginPanelController *_spotifyLoginPanelController;
    BFNavigationController *_navController;
    AUEffectTestViewController *_effectTestViewController;
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    NSError *error = nil;
	[SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size]
											   userAgent:@"com.jasondreisbach.aurora"
										   loadingPolicy:SPAsyncLoadingManual
												   error:&error];
	if (error != nil) {
		NSLog(@"CocoaLibSpotify init failed: %@", error);
		abort();
	}
    
	[[SPSession sharedSession] setDelegate:self];
    
    [[DPHue sharedInstance] setDelegate:self];
    [[DPHue sharedInstance] startDiscovery];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    
    NSInteger musicTabIndex = [self.tabView indexOfTabViewItemWithIdentifier:@"music"];
    NSTabViewItem *musicTabItem = [self.tabView tabViewItemAtIndex:musicTabIndex];
    _navController = [[BFNavigationController alloc] initWithFrame:[musicTabItem.view frame] rootViewController:nil];
    musicTabItem.view = _navController.view;
    
    
    NSInteger hueTabIndex = [self.tabView indexOfTabViewItemWithIdentifier:@"hue"];
    NSTabViewItem *hueTabItem = [self.tabView tabViewItemAtIndex:hueTabIndex];
    _effectTestViewController = [[AUEffectTestViewController alloc] initWithNibName:@"AUEffectTestView" bundle:nil];
    
    hueTabItem.view = _effectTestViewController.view;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"spotify_username"];
    NSString *credential =  [defaults objectForKey:@"spotify_credential"];
    if ([credential length] > 0) {
        [[SPSession sharedSession] attemptLoginWithUserName:username existingCredential:credential];
    }
    else {
        [self showLoginSheet:self];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (IBAction)showLoginSheet:(id)sender
{
    // Log out if necessary
    if (_spotifyLoginPanelController == nil) {
        _spotifyLoginPanelController = [[AUSpotifyLoginPanelController alloc] initWithWindowNibName:@"AUSpotifyLoginPanel"];
    }
    [_spotifyLoginPanelController reset];
    
    if([_spotifyLoginPanelController.window isModalPanel] == NO) {
        [NSApp beginSheet:_spotifyLoginPanelController.window
           modalForWindow:self.window
            modalDelegate:self
           didEndSelector:@selector(loginSheetDidEnd:returnCode:contextInfo:)
              contextInfo:nil];
    }
}

- (void)loginSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode == NSCancelButton) {
        [NSApp stopModal];
        [NSApp terminate:self];
    }
    else if (returnCode == NSOKButton) {
        [_spotifyLoginPanelController save];
        [_spotifyLoginPanelController.window orderOut:self];
        _spotifyLoginPanelController = nil;
    }
}

- (void)alertUserToPressLinkButtonOnBridge:(DPHueBridge *)bridge
{
    // TODO: implement a popover or some type of ui to alert the user
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, bridge);
}

- (IBAction)refreshHueData:(id)sender
{
    [[DPHue sharedInstance] reloadBridgeData];
}

- (IBAction)debugHueData:(id)sender
{
    NSUInteger index = 0;
    for (DPHueBridge *bridge in [[DPHue sharedInstance] bridges]) {
        [bridge readWithCompletion:^(id object, NSError *err) {
        }];
        NSLog(@"%lu: %@", (unsigned long)index, bridge);
    }
}

- (IBAction)testHueChange:(id)sender
{
    DPHueBridge *bridge = [[[DPHue sharedInstance] bridges] lastObject];
    [bridge allLightsOff];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:1.0];
    
    NSMutableArray *scheduleArray = [NSMutableArray array];
    
    //    for (DPHueLight *light in bridge.lights) {
    
    DPHueLight *light = [bridge.lights objectAtIndex:0];
    for (int i = 0; i < 5; i++) {
        
        DPHueSchedule *schedule = [[DPHueSchedule alloc] initWithBridge:bridge];
        schedule.command = @{
                             @"address" : light.state.address,
                             @"method" : @"PUT",
                             @"body" : @{
                                     @"on": @YES,
                                     @"bri": @100,
                                     @"transitiontime": @0
                                     }
                             };
        schedule.date = date;
        [schedule write];
        [scheduleArray addObject:schedule];
        
        date = [date dateByAddingTimeInterval:0.5];
        
        schedule = [[DPHueSchedule alloc] initWithBridge:bridge];
        schedule.command = @{
                             @"address" : light.state.address,
                             @"method" : @"PUT",
                             @"body" : @{
                                     @"on": @NO,
                                     @"bri": @0,
                                     @"transitiontime": @0
                                     }
                             };
        schedule.date = date;
        [schedule write];
        [scheduleArray addObject:schedule];
        
        date = [date dateByAddingTimeInterval:0.5];
    }
    //    }
}

- (IBAction)testEffect:(id)sender
{
    static dispatch_queue_t lightQueue = NULL;
    if (lightQueue == NULL)
        lightQueue = dispatch_queue_create("com.apple.aurora.light.q2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_time_t startTime = DISPATCH_TIME_NOW;
    {
        DPHueLight *light = [[[DPHue sharedInstance] lights] objectAtIndex:3];
        AUStrobe *strobeEffect = [[AUStrobe alloc] init];
        strobeEffect.color = [NSColor blueColor];

        strobeEffect.startTime = 0;
        strobeEffect.duration = 20.0;
        strobeEffect.frequency = 1.05263;
        NSDictionary *payloads = strobeEffect.payloads;

        for (NSNumber *dispatchTime in payloads.allKeys)
        {
            double delayInSeconds = [dispatchTime doubleValue];
            dispatch_time_t popTime = dispatch_time(startTime, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, lightQueue, ^(void){
                [light.state.pendingChanges removeAllObjects];
                [light.state.pendingChanges addEntriesFromDictionary:payloads[dispatchTime]];
                [light write];
            });
        }
    }
    {
        DPHueLight *light = [[[DPHue sharedInstance] lights] objectAtIndex:4];
        AUStrobe *strobeEffect = [[AUStrobe alloc] init];
        strobeEffect.color = [NSColor redColor];
        strobeEffect.startTime = .475;
        strobeEffect.duration = 20.0;
        strobeEffect.frequency = 1.05263;
        NSDictionary *payloads = strobeEffect.payloads;
        for (NSNumber *dispatchTime in payloads.allKeys)
        {
            double delayInSeconds = [dispatchTime doubleValue];
            dispatch_time_t popTime = dispatch_time(startTime, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, lightQueue, ^(void){
                [light.state.pendingChanges removeAllObjects];
                [light.state.pendingChanges addEntriesFromDictionary:payloads[dispatchTime]];
                [light write];
            });
        }
    }
    {
        DPHueLight *light = [[[DPHue sharedInstance] lights] objectAtIndex:0];
        double interval = 3.8;
        double gotime = 0.9;
        
        NSMutableDictionary *payloads = [NSMutableDictionary dictionary];

        [payloads setObject:@{@"color": [NSColor blueColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor greenColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor purpleColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor redColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor blueColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor orangeColor]} forKey:@(gotime)];
        gotime += interval;
        for (NSNumber *dispatchTime in payloads.allKeys)
        {
            double delayInSeconds = [dispatchTime doubleValue];
            dispatch_time_t popTime = dispatch_time(startTime, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, lightQueue, ^(void){
                [light.state.pendingChanges removeAllObjects];
                light.on = YES;
                light.color = payloads[dispatchTime][@"color"];
                light.brightness = @255;
                light.transitionTime = @4;
                [light write];
            });
            dispatch_after(dispatch_time(popTime, (int64_t)(0.2 * NSEC_PER_SEC)), lightQueue, ^(void){
                [light.state.pendingChanges removeAllObjects];
                light.brightness = @50;
                light.transitionTime =  @20;
                [light write];
            });
        }
    }
    {
        DPHueLight *light = [[[DPHue sharedInstance] lights] objectAtIndex:1];
        double interval = 3.8;
        double gotime = 0.9;
        
        NSMutableDictionary *payloads = [NSMutableDictionary dictionary];
        
        [payloads setObject:@{@"color": [NSColor blueColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor greenColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor purpleColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor redColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor blueColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor orangeColor]} forKey:@(gotime)];
        gotime += interval;
        for (NSNumber *dispatchTime in payloads.allKeys)
        {
            double delayInSeconds = [dispatchTime doubleValue];
            dispatch_time_t popTime = dispatch_time(startTime, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, lightQueue, ^(void){
                [light.state.pendingChanges removeAllObjects];
                light.on = YES;
                light.color = payloads[dispatchTime][@"color"];
                light.brightness = @255;
                light.transitionTime = @4;
                [light write];
            });
            dispatch_after(dispatch_time(popTime, (int64_t)(0.2 * NSEC_PER_SEC)), lightQueue, ^(void){
                [light.state.pendingChanges removeAllObjects];
                light.brightness = @50;
                light.transitionTime =  @20;
                [light write];
            });
        }
    }
    {
        DPHueLight *light = [[[DPHue sharedInstance] lights] objectAtIndex:2];
        double interval = 3.8;
        double gotime = 0.9;
        
        NSMutableDictionary *payloads = [NSMutableDictionary dictionary];
        
        [payloads setObject:@{@"color": [NSColor blueColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor greenColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor purpleColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor redColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor blueColor]} forKey:@(gotime)];
        gotime += interval;
        [payloads setObject:@{@"color": [NSColor orangeColor]} forKey:@(gotime)];
        gotime += interval;
        for (NSNumber *dispatchTime in payloads.allKeys)
        {
            double delayInSeconds = [dispatchTime doubleValue];
            dispatch_time_t popTime = dispatch_time(startTime, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, lightQueue, ^(void){
                [light.state.pendingChanges removeAllObjects];
                light.on = YES;
                light.color = payloads[dispatchTime][@"color"];
                light.brightness = @255;
                light.transitionTime = @4;
                [light write];
            });
            dispatch_after(dispatch_time(popTime, (int64_t)(0.2 * NSEC_PER_SEC)), lightQueue, ^(void){
                [light.state.pendingChanges removeAllObjects];
                light.brightness = @50;
                light.transitionTime =  @20;
                [light write];
            });
        }
    }
    
}

- (IBAction)testHueChangeDispatch:(id)sender
{
    DPHueBridge *bridge = [[[DPHue sharedInstance] bridges] lastObject];
    
    static dispatch_queue_t lightQueue = NULL;
    if (lightQueue == NULL)
        lightQueue = dispatch_queue_create("com.apple.aurora.light.q", DISPATCH_QUEUE_CONCURRENT);
    double delayInSeconds = 0.02;
    
    //    for (DPHueLight *light in bridge.lights) {
    DPHueLight *light = [bridge.lights objectAtIndex:0];
    dispatch_time_t popTime = DISPATCH_TIME_NOW;
    for (int i = 0; i < 10; i++) {
        popTime = dispatch_time(popTime, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, lightQueue, ^(void){
            [light.state.pendingChanges addEntriesFromDictionary:@{
             @"on": @NO,
             @"bri": @0
             }];
            light.transitionTime = @0;
            [light write];
        });
        popTime = dispatch_time(popTime, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, lightQueue, ^(void){
            [light.state.pendingChanges addEntriesFromDictionary:@{
             @"on": @YES,
             @"bri": @255,
             @"hue" : @400,
             @"sat" : @200
             }];
            light.transitionTime = @0;
            [light write];
        });
        //        }
    }
}
#pragma mark -
#pragma mark SPSession Delegates

- (void)sessionDidLoginSuccessfully:(SPSession *)aSession
{
    if ([_spotifyLoginPanelController.window isModalPanel])
        [NSApp endSheet:_spotifyLoginPanelController.window returnCode:NSOKButton];
    
    AUPlaybackCoordinator *playbackCoordinator = [AUPlaybackCoordinator initializeSharedInstance];
    [self.playbackObjectController setContent:playbackCoordinator];
    
    AUSpotifyViewController *spotifyViewController = [[AUSpotifyViewController alloc] initWithNibName:@"AUSpotifyView" bundle:nil];
    [_navController pushViewController:spotifyViewController animated:NO];
}

- (void)session:(SPSession *)aSession didGenerateLoginCredentials:(NSString *)credential forUserName:(NSString *)userName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:@"spotify_username"];
    [defaults setObject:credential forKey:@"spotify_credential"];
    [defaults synchronize];
}

- (void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error
{
	// Invoked by SPSession after a failed login.
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    [_spotifyLoginPanelController reset];
}

- (void)sessionDidLogOut:(SPSession *)aSession
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
}

- (void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage; {
    
	[[NSAlert alertWithMessageText:aMessage
					 defaultButton:@"OK"
				   alternateButton:@""
					   otherButton:@""
		 informativeTextWithFormat:@"This message was sent to you from the Spotify service."] runModal];
}


#pragma mark -
#pragma Playback Coordinator Actions

- (IBAction)playPause:(id)sender
{
    // l
}

- (IBAction)nextTrack:(id)sender
{
    [[AUPlaybackCoordinator sharedInstance] nextTrack];
}

- (IBAction)previousTrack:(id)sender
{
    [[AUPlaybackCoordinator sharedInstance] previousTrack];
}

- (IBAction)seekToPosition:(id)sender
{
    if ([sender isKindOfClass:[NSSlider class]]) {
        NSSlider *slider = sender;
        [[AUPlaybackCoordinator sharedInstance] seekToTrackPosition:slider.doubleValue];
    }
}


@end
