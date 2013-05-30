//
//  AUEffectView.h
//  Aurora
//
//  Created by Jason Dreisbach on 5/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AUEffectEditViewController.h"

@class AUEffect;

@interface AUEffectView : NSView <AUEffectEditViewControllerDelegate>

@property (strong) AUEffect *effect;

- (void)layoutView;

@end
