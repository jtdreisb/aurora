//
//  SPTrack+AUAdditions.h
//  Aurora
//
//  Created by Jason Dreisbach on 5/16/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <CocoaLibSpotify/CocoaLibSpotify.h>

@class AUTimeline;

@interface SPTrack (AUAdditions)

@property (readonly) AUTimeline *timeline;

- (void)saveTimeline;

@end
