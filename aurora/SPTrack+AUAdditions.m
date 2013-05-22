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

- (NSString *)timelineFilePath
{
    NSString *timelinePath = [[NSFileManager defaultManager] applicationSupportDirectory];
    NSString *identifier = [[[self.spotifyURL absoluteString] componentsSeparatedByString:@":"] lastObject];
    return [timelinePath stringByAppendingFormat:@"/timelines/%@.au", identifier];
}

- (AUTimeline *)timeline
{
    static AUTimeline *timeline = nil;
    @synchronized(self) {
        if (timeline == nil) {
            timeline = [[AUTimeline alloc] initWithContentsOfPath:self.timelineFilePath];
            timeline.duration = self.duration;
        }
    }
    return timeline;
}

- (void)saveTimeline
{
    [self.timeline writeToFile:self.timelineFilePath];
}

@end
