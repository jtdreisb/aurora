//
//  AUEffectTestViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUEffectTestViewController.h"
#import "AUEffect.h"

@implementation AUEffectTestViewController

- (void)awakeFromNib
{
    // bind our collection view's contents and selection to our array controller
	[self.effectCollectionView bind:@"content" toObject:self.effectsArrayController withKeyPath:@"arrangedObjects" options:nil];
	[self.effectCollectionView bind:@"selectionIndexes" toObject:self.effectsArrayController withKeyPath:@"selectionIndexes" options:nil];
    
    
	[self.effectCollectionView setFocusRingType:NSFocusRingTypeNone];	// we don't want a focus ring
	[self.effectCollectionView setSelectable:NO]; // not selectable

    if ([self.effectsArrayController.arrangedObjects count] == 0) {
        AUEffect *effect = [[AUEffect alloc] init];
        [self.effectsArrayController addObject:effect];
        effect = [[AUEffect alloc] init];
        [self.effectsArrayController addObject:effect];
    }
}


- (void)addLights:(NSArray *)lights
{
    for (id light in lights) {
        NSMutableDictionary *lightDictionary = [NSMutableDictionary dictionary];
        [lightDictionary setObject:@NO forKey:@"enabled"];
        [lightDictionary setObject:light forKey:@"light"];
        [self.lightsArrayController addObject:lightDictionary];
    }
}

#pragma mark - NSTableViewDelegate

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)tableView
{
    return NO;
}


@end
