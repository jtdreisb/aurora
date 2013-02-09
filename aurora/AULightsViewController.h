//
//  AULightsViewController.h
//  aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DPHueBridge;
@class AULightEditViewController;
@class AUSpotifyViewController;

@interface AULightsViewController : NSViewController <NSTableViewDelegate>

@property (nonatomic, strong) DPHueBridge *hue;
@property (nonatomic, weak) IBOutlet NSTableView *tableView;
@property (nonatomic, weak) IBOutlet NSArrayController *lightArrayController;

@property (nonatomic, weak) IBOutlet AULightEditViewController *lightEditViewController;
@property (nonatomic, weak) IBOutlet AUSpotifyViewController *spotifyViewController;

@end
