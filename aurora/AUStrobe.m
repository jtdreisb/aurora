//
//  AUStrobeEffect.m
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUStrobe.h"

#define kColorKey @"color"
#define kFrequencyKey @"frequency"
#define ktransitionTimeKey @"transitiontime"

#define kDefaultChangeTimeInterval 0.1

@implementation AUStrobe

- (id)init
{
    self = [super init];
    if (self != nil) {
        _color = [NSColor whiteColor];
        _frequency = 2.0;
        _transitionTime = 0.0;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        _color = [aDecoder decodeObjectForKey:kColorKey];
        _frequency = [aDecoder decodeDoubleForKey:kFrequencyKey];
        _transitionTime = [aDecoder decodeDoubleForKey:ktransitionTimeKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_color forKey:kColorKey];
    [aCoder encodeDouble:_frequency forKey:kFrequencyKey];
    [aCoder encodeDouble:_transitionTime forKey:ktransitionTimeKey];
}

#pragma mark - Readonly

// For subclasses to override
+ (NSString *)name
{
    return @"Strobe";
}
+ (NSString *)toolTip
{
    return @"Flashing lights at a certain frequency";
}

+ (NSImage *)image;
{
    NSImage *image = [NSImage imageNamed:@"editing-done"];
    [image setTemplate:YES];
    return image;
}

+ (NSString *)editViewNibName
{
    return @"AUStrobeEffectEditView";
}

- (NSColor *)backgroundColor
{
    return [NSColor colorWithCalibratedRed:0.2 green:0.7 blue:0.2 alpha:0.9];
}

- (NSDictionary *)payloads
{
    NSMutableDictionary *payloads = [NSMutableDictionary dictionary];
    NSNumber *dispatchTime = [NSNumber numberWithDouble:self.startTime];
    NSNumber *endTime = [NSNumber numberWithDouble:(self.startTime + self.duration)];
    
    NSTimeInterval intervalStep = kDefaultChangeTimeInterval;
    if (self.frequency > 0) {
        intervalStep = 1.0 / self.frequency;
    }
    
    while ([dispatchTime isLessThan:endTime]) {
        NSMutableDictionary *payload = [NSMutableDictionary dictionary];

        NSColor *color = [self.color colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
        payload[@"hue"] = @([[NSNumber numberWithDouble:[color hueComponent] * 65535] integerValue]);
        payload[@"sat"] = @([[NSNumber numberWithDouble:[color saturationComponent] * 255] integerValue]);
        payload[@"bri"] = @([[NSNumber numberWithDouble:[color brightnessComponent] * 255] integerValue]);
        
        payload[@"on"] = @YES;
        payload[@"transitiontime"] = @(self.transitionTime);
        
        [payloads setObject:payload forKey:dispatchTime];
        dispatchTime = [NSNumber numberWithDouble:[dispatchTime doubleValue] + intervalStep/2.0];
        
        [payloads setObject:@{
         @"on" : @NO,
         @"bri": @0,
         @"transitiontime" : @(self.transitionTime)
         } forKey:dispatchTime];
        
        dispatchTime = [NSNumber numberWithDouble:[dispatchTime doubleValue] + intervalStep/2.0];
    }
    
    return payloads;
}

@end
