//
//  AUColorEffect.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUColorEffect.h"

#define kColorKey @"color"
#define kOnOffKey @"onoff"

@implementation AUColorEffect

- (id)init
{
    self = [super init];
    if (self != nil) {
        _onOFF = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        _color = [aDecoder decodeObjectForKey:kColorKey];
        _onOFF = [aDecoder decodeBoolForKey:kOnOffKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_color forKey:kColorKey];
    [aCoder encodeBool:_onOFF forKey:kOnOffKey];
}

- (id)copyWithZone:(NSZone *)zone
{
    AUColorEffect *effect = [super copyWithZone:zone];
    effect.color = [self.color copy];
    effect.onOFF = self.onOFF;
    return effect;
}

#pragma mark - Readonly

// For subclasses to override
+ (NSString *)name
{
    return @"Color";
}

+ (NSString *)toolTip
{
    return @"Make the bulb turn a certain color";
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
    payload[@"on"] = @(_onOFF);
    payload[@"transitiontime"] = @(self.duration*10.0);

    return @{dispatchTime: payload};
}

@end
