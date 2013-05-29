//
//  AUEffectEditViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 5/23/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol AUEffectEditViewControllerDelegate <NSObject>

- (void)saveEffect:(id)sender;
- (void)deleteEffect:(id)sender;

@end

@interface AUEffectEditViewController : NSViewController

- (IBAction)saveEffect:(id)sender;
- (IBAction)deleteEffect:(id)sender;

@property (weak) id<AUEffectEditViewControllerDelegate> delegate;

@end

