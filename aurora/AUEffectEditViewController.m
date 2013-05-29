//
//  AUEffectEditViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/23/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUEffectEditViewController.h"

@interface AUEffectEditViewController ()

@end

@implementation AUEffectEditViewController

- (IBAction)saveEffect:(id)sender
{
    [self.delegate saveEffect:self.representedObject];
}

- (IBAction)deleteEffect:(id)sender
{
    [self.delegate deleteEffect:self.representedObject];
}

@end
