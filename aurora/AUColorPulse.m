//
//  AUColorPulse.m
//  Aurora
//
//  Created by Jason Dreisbach on 4/9/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUColorPulse.h"

@implementation AUColorPulse

// For subclasses to override
- (NSString *)name
{
    return @"Color Pulse";
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

@end
