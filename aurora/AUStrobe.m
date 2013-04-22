//
//  AUStrobeEffect.m
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUStrobe.h"

@implementation AUStrobe

- (id)initWithFrequency:(NSNumber *)frequency
{
    self = [super init];
    if (self != nil) {
        _frequency = frequency;
    }
    return self;
}

#pragma mark - Readonly

// For subclasses to override
- (NSString *)name
{
    return @"Strobe";
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
