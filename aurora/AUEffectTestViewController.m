//
//  AUEffectTestViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUEffectTestViewController.h"
#import "AUEffect.h"
#import "AUStrobe.h"
#import "AUColorPulse.h"

#import <DPHue.h>

@implementation AUEffectTestViewController

- (void)awakeFromNib
{
    // bind our collection view's contents and selection to our array controller
	[_effectCollectionView bind:@"content" toObject:_effectsArrayController withKeyPath:@"arrangedObjects" options:nil];
	[_effectCollectionView bind:@"selectionIndexes" toObject:_effectsArrayController withKeyPath:@"selectionIndexes" options:nil];
    [_lightsArrayController bind:@"content" toObject:[DPHue sharedInstance] withKeyPath:@"lights" options:nil];
    
	[_effectCollectionView setFocusRingType:NSFocusRingTypeNone];	// we don't want a focus ring
	[_effectCollectionView setSelectable:NO]; // not selectable

    if ([self.effectsArrayController.arrangedObjects count] == 0) {
        AUEffect *effect = [[AUEffect alloc] init];
        [self.effectsArrayController addObject:effect];
        effect = [[AUStrobe alloc] init];
        [self.effectsArrayController addObject:effect];
        effect = [[AUColorPulse alloc] init];
        [self.effectsArrayController addObject:effect];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    
}

#pragma mark - NSTableViewDelegate

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)tableView
{
    return NO;
}


@end
