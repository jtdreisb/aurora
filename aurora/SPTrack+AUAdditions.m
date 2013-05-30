//
//  SPTrack+AUAdditions.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/16/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "SPTrack+AUAdditions.h"
#import "AUTimeline.h"
#import "NSFileManager+DirectoryLocations.h"

@implementation SPTrack (AUAdditions)

+ (NSMutableDictionary *)au_propertyDictionary
{
    static NSMutableDictionary *propertyDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyDictionary = [NSMutableDictionary dictionary];
    });
    return propertyDictionary;
}

- (NSMutableDictionary *)au_properties
{
    return [[[self class] au_propertyDictionary] objectForKey:[NSValue valueWithPointer:(__bridge const void *)(self)]] ?: [NSMutableDictionary dictionary];
}

- (void)au_saveProperties:(NSMutableDictionary *)objectProperties
{
    [[[self class] au_propertyDictionary] setObject:objectProperties forKey:[NSValue valueWithPointer:(__bridge const void *)(self)]];
}

- (NSString *)timelineFilePath
{
    NSString *timelinePath = [[NSFileManager defaultManager] applicationSupportDirectory];
    NSString *identifier = [[[self.spotifyURL absoluteString] componentsSeparatedByString:@":"] lastObject];
    return [timelinePath stringByAppendingFormat:@"/timelines/%@.au", identifier];
}

- (AUTimeline *)timeline
{
    AUTimeline *timeline = nil;
    @synchronized(self) {
        NSMutableDictionary *properties = [self au_properties];
        timeline = properties[@"timeline"];
        if (timeline == nil) {
            timeline = [[AUTimeline alloc] initWithContentsOfPath:self.timelineFilePath];
            timeline.duration = self.duration;
            properties[@"timeline"] = timeline;
            [self au_saveProperties:properties];
        }
    }
    return timeline;
}

- (void)saveTimeline
{
    [self.timeline writeToFile:self.timelineFilePath];
}

@end
