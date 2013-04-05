//
//  AUEffectViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUEffectViewController.h"

@interface AUEffectViewController ()

@end

@implementation AUEffectViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self addObserver:self forKeyPath:@"effect" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"effect"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if (object == self && [keyPath isEqualToString:@"effect"]) {
        NSLog(@"object %@", object);
    }
}

- (IBAction)showEditPopover:(id)sender
{
    NSLog(@"Note implemented");
}

@end
