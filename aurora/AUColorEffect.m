//
//  AUColorEffect.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUColorEffect.h"
#import <DPHueLight.h>

#define kColorKey @"color"
#define kTransitionTimeKey @"transitiontime"

@implementation AUColorEffect

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        _color = [aDecoder decodeObjectForKey:kColorKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_color forKey:kColorKey];
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
    NSNumber *dispatchTime = [NSNumber numberWithDouble:self.startTime];
    
    DPHueLight *light = [[DPHueLight alloc] initWithBridge:nil];
    light.color = self.color;
    
    NSMutableDictionary *payload = [light.state.pendingChanges mutableCopy];
    payload[@"on"] = @YES;
    payload[@"transitiontime"] = @(self.duration*10.0);

    return @{dispatchTime: payload};
}

@end
