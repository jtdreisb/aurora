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

@interface AUEffectCollectionViewItem ()

@end

@implementation AUEffectCollectionViewItem
{
    BOOL setup;
}
- (IBAction)startStopButton:(id)sender
{
    
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
    if ([representedObject isKindOfClass:[AUEffect class]]) {
        [self.effectViewController setEffect:representedObject];
    }
}

@end
