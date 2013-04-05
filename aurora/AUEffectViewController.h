//
//  AUEffectViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AUEffect;

@interface AUEffectViewController : NSViewController

@property (strong, nonatomic) IBOutlet NSTextField *titleLabel;
@property (strong, nonatomic) IBOutlet NSImageView *imageView;

@property (strong, nonatomic) AUEffect *effect;

- (IBAction)showEditPopover:(id)sender;

@end
