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
	[[self view] bind:@"content" toObject:self.effectsArrayController withKeyPath:@"arrangedObjects" options:nil];
	[[self view] bind:@"selectionIndexes" toObject:self.effectsArrayController withKeyPath:@"selectionIndexes" options:nil];
    
    
    NSCollectionView *collectionView = (NSCollectionView *)[self view];
	[collectionView setFocusRingType:NSFocusRingTypeNone];	// we don't want a focus ring
	[collectionView setSelectable:NO]; // not selectable
    

    if ([self.effectsArrayController.arrangedObjects count] == 0) {
        AUEffect *effect = [[AUEffect alloc] init];
        [self.effectsArrayController addObject:effect];
        effect = [[AUEffect alloc] init];
        [self.effectsArrayController addObject:effect];
    }
}




@end
