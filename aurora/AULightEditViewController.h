//
//  AULightEditViewController.h
//  aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DPHueLight;

@interface AULightEditViewController : NSViewController

@property (weak) IBOutlet NSViewController *parentViewController;
@property (weak) IBOutlet NSTextField *transtionTimeTextField;
@property (strong) DPHueLight *light;


- (IBAction)back:(id)sender;

- (IBAction)set:(id)sender;

@end
