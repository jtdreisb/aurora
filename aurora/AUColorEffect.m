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

- (NSColor *)backgroundColor
{
    return [self.color colorWithAlphaComponent:0.9];
}

- (NSDictionary *)payloads
{
    NSNumber *dispatchTime = [NSNumber numberWithDouble:self.startTime];
    NSMutableDictionary *payload = [NSMutableDictionary dictionary];
    NSColor *color = [self.color colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
    payload[@"hue"] = @([[NSNumber numberWithDouble:[color hueComponent] * 65535] integerValue]);
    payload[@"sat"] = @([[NSNumber numberWithDouble:[color saturationComponent] * 255] integerValue]);
    payload[@"bri"] = @([[NSNumber numberWithDouble:[color brightnessComponent] * 255] integerValue]);
    payload[@"on"] = @YES;
    payload[@"transitiontime"] = @(self.duration*10.0);

    return @{dispatchTime: payload};
}

@end
