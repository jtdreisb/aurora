//
//  AULightEditViewController.m
//  aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AULightEditViewController.h"
#import <DPHue/DPHueLight.h>

@interface AULightEditViewController ()

@end

@implementation AULightEditViewController

- (IBAction)back:(id)sender
{
    if (self.parentViewController != nil) {
        self.parentViewController.view.frame = self.view.frame;
        [self.view.superview addSubview:self.parentViewController.view];
        [self.view removeFromSuperview];
        
    }
}

- (IBAction)set:(id)sender
{
    [self.light write];
}

- (IBAction)autoUpdate:(id)sender
{
    self.light.holdUpdates = !self.light.holdUpdates;
}


- (IBAction)setTranstionTime:(id)sender
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    self.light.transitionTime = [formatter numberFromString:self.transtionTimeTextField.stringValue];
}

@end
