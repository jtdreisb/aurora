//
//  AUColorEffect.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUColorEffect.h"

#define kColorKey @"color"
#define kTransitionTimeKey @"transitiontime"

@implementation AUColorEffect

- (id)init
{
    self = [super init];
    if (self != nil) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self != nil) {
        _color = [aDecoder decodeObjectForKey:kColorKey];
        _transitionTime = [aDecoder decodeDoubleForKey:kTransitionTimeKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_color forKey:kColorKey];
    [aCoder encodeDouble:_transitionTime forKey:kTransitionTimeKey];
}

#pragma mark - Readonly

// For subclasses to override
+ (NSString *)name
{
    return @"Color";
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

+ (NSString *)editViewNibName
{
    return @"AUColorEffectEditView";
}


- (NSDictionary *)payloads
{
    return nil;
}

@end
