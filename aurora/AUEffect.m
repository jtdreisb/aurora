//
//  AUEffect.m
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUEffect.h"

@implementation AUEffect

#pragma mark - Readonly

// For subclasses to override
- (NSString *)name
{
    return @"Blank Effect";
}
- (NSString *)toolTip
{
    return @"Description of the effect";
}

- (NSImage *)image;
{
    NSImage *image = [NSImage imageNamed:@"editing-done"];
    [image setTemplate:YES];
    return image;
}

- (NSString *)editViewNibName
{
    return @"AUEffectEditView";
}

#pragma mark - Actions

- (void)start
{
    NSLog(@"start");
}

- (void)stop
{
    NSLog(@"stop");
}



@end
