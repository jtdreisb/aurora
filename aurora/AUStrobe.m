//
//  AUStrobeEffect.m
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUStrobe.h"
#import <DPHueLight.h>

#define kDefaultChangeTimeInterval 0.1


@implementation AUStrobe

- (id)init
{
    self = [super init];
    if (self != nil) {
    }
    return self;
}

- (id)initWithFrequency:(NSTimeInterval)frequency
{
    self = [self init];
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

- (NSDictionary *)payloads
{
    NSMutableDictionary *payloads = [NSMutableDictionary dictionary];
    NSNumber *dispatchTime = [NSNumber numberWithDouble:self.startTime];
    NSNumber *endTime = [NSNumber numberWithDouble:(self.startTime + self.duration)];
    
    NSTimeInterval intervalStep = kDefaultChangeTimeInterval;
    if (self.frequency > 0) {
        intervalStep = 1.0 / self.frequency;
    }
    
    DPHueLight *light = [[DPHueLight alloc] initWithBridge:nil];
    while ([dispatchTime isLessThan:endTime]) {
        NSMutableDictionary *payload = nil;
        // ON
        if (self.color != nil) {
            light.color = self.color;
        }
        else {
            light.color = [NSColor whiteColor];
        }
        payload = [light.state.pendingChanges mutableCopy];
        [payload setObject:@YES forKey:@"on"];
        [payload setObject:@(self.transitionTime) forKey:@"transitiontime"];
        
        [payloads setObject:payload forKey:dispatchTime];
        dispatchTime = [NSNumber numberWithDouble:[dispatchTime doubleValue] + intervalStep/2.0];
        
        [light.pendingChanges removeAllObjects];
        
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
