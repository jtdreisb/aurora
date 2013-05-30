//
//  AUEffect.m
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUEffect.h"

#define kStartTimeKey @"starttime"
#define kDurationKey @"duration"

@implementation AUEffect

- (id)init
{
    self = [super init];
    if (self != nil) {
        _startTime = 0.0;
        _duration = 1.0;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self != nil) {
        _startTime = [aDecoder decodeDoubleForKey:kStartTimeKey];
        _duration = [aDecoder decodeDoubleForKey:kDurationKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:_startTime forKey:kStartTimeKey];
    [aCoder encodeDouble:_duration forKey:kDurationKey];
}

- (id)copyWithZone:(NSZone *)zone
{
    AUEffect *effect = [[[self class] alloc] init];
    effect.startTime = self.startTime;
    effect.duration = self.duration;
    return effect;
}

#pragma mark - Readonly

// For subclasses to override
+ (NSString *)name
{
    return @"Effect";
}

+ (NSString *)toolTip
{
    return @"Description of the effect";
}

+ (NSImage *)image;
{
    NSImage *image = [NSImage imageNamed:@"editing-done"];
    [image setTemplate:YES];
    return image;
}

- (NSColor *)backgroundColor
{
    return [NSColor colorWithCalibratedRed:1.0 green:0.5 blue:0.2 alpha:0.9];
}

+ (NSString *)editViewNibName
{
    return @"AUEffectEditView";
}

- (AUEffectEditViewController *)editViewController
{
    AUEffectEditViewController *editController = [[AUEffectEditViewController alloc] initWithNibName:[[self class] editViewNibName] bundle:nil];
    editController.representedObject = self;
    return editController;
}

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    static NSArray *writableTypes = nil;
    
    if (!writableTypes) {
//        writableTypes = @[<#objects, ...#>];
    }
    return writableTypes;
}

#pragma mark - Actions

- (NSDictionary *)payloads
{
    return @{};
}


@end
