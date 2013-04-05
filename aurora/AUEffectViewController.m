//
//  AUEffectViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUEffectViewController.h"
#import "AUEffect.h"

@implementation AUEffectViewController
{
    NSPopover *_editPopover;
}

- (IBAction)showEditPopover:(id)sender
{
    if (_editPopover == nil) {
        _editPopover = [[NSPopover alloc] init];
    }
    if ([_editPopover isShown]) {
        [_editPopover close];
        _editPopover = nil;
    }
    else {
        NSViewController *popoverViewController = [[NSViewController alloc] initWithNibName:self.effect.editViewNibName bundle:nil];
        _editPopover.contentViewController = popoverViewController;
        
        [_editPopover showRelativeToRect:[sender bounds]
                                      ofView:sender
                               preferredEdge:NSMaxYEdge];
    }
}

@end
