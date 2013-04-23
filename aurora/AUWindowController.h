//
//  AUWindowController.h
//  Aurora
//
//  Created by Jason Dreisbach on 2/8/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <DPHue/DPHue.h>
#import "BFNavigationController.h"

@interface AUWindowController : NSWindowController <DPHueDiscoverDelegate>

@property (strong) IBOutlet NSArrayController *lightArrayController;

@property (strong) IBOutlet NSTabView *tabView;

@property (strong) IBOutlet NSViewController *performanceViewController;

// TODO: delete after debugging
@property (strong, readonly) BFNavigationController *navController;
@property (strong) IBOutlet NSViewController *effectTestViewController;
@property (strong) IBOutlet NSViewController *spotifyViewController;

@end
