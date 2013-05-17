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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
    return timeline;
}

- (void)saveTimeline
{

}

@end
