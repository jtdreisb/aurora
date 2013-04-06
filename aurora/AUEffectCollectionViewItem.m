//
//  AUEffectCollectionViewItem.m
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUEffectCollectionViewItem.h"
#import "AUEffectViewController.h"
#import "AUEffect.h"

@implementation AUEffectCollectionViewItem

- (IBAction)startStopButton:(id)sender
{
        NSLog(@"%@", self.effectViewController);
        NSLog(@"%@", [self.effectViewController valueForKey:@"editPopover"]);
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
    
    // HACK: this is to load the effectviewcontroller property
    // otherwise it will be nil
    [self view];
    
    if ([representedObject isKindOfClass:[AUEffect class]]) {
        self.effectViewController.effect = (AUEffect *)representedObject;
    }
}

@end
